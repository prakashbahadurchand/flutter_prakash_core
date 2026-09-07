import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/blocs/blocs.dart';
import 'package:flutter_prakash_core/src/network/network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Concrete implementations for testing
class TestCountCubit extends BaseCubit<int> {
  TestCountCubit() : super(0);

  void increment() {
    final next = state + 1;
    safeEmit(next);
    emitEffect(ShowToastEffect('Incremented to $next'));
  }
}

class TestUiCubit extends BaseUiCubit<String> {
  Future<void> loadData({bool shouldFail = false}) async {
    await executeResult(
      call: () async {
        if (shouldFail) {
          return const Result.error(ServerFailure('Failed to load'));
        }
        return const Result.success('Loaded UI Data');
      },
    );
  }
}

// Events and BLoC for EventTransformers test
sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryEvent extends SearchEvent {
  final String query;
  const SearchQueryEvent(this.query);
}

class SearchBloc extends BaseBloc<SearchEvent, List<String>> {
  SearchBloc() : super(const []) {
    on<SearchQueryEvent>(
      (event, emit) async {
        safeEmit([...state, event.query], emit);
      },
      transformer: FpEventTransformers.debounce(
        const Duration(milliseconds: 50),
      ),
    );
  }
}

class SampleAppEvent extends AppEvent<String> {
  const SampleAppEvent(super.payload);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BaseCubit & FpEffects', () {
    test('BaseCubit handles safeEmit and emits side-effects', () async {
      final cubit = TestCountCubit();
      final effects = <FpEffect>[];
      final sub = cubit.effectStream.listen(effects.add);

      expect(cubit.state, equals(0));
      cubit.increment();
      expect(cubit.state, equals(1));

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(effects.length, equals(1));
      expect(effects.first, isA<ShowToastEffect>());
      expect(
        (effects.first as ShowToastEffect).message,
        equals('Incremented to 1'),
      );

      await sub.cancel();
      await cubit.close();

      // safeEmit after close does not throw StateError
      cubit.safeEmit(99);
      expect(cubit.state, equals(1));
    });
  });

  group('BaseUiCubit & UiState', () {
    test(
      'UiState state transitions (initial -> loading -> success / failure)',
      () async {
        final cubit = TestUiCubit();

        expect(cubit.state.isInitial, isTrue);

        // Successful fetch
        final successFuture = cubit.loadData();
        expect(cubit.state.isLoading, isTrue);
        await successFuture;
        expect(cubit.state.isSuccess, isTrue);
        expect(cubit.state.dataOrNull, equals('Loaded UI Data'));

        // Failing fetch
        final failFuture = cubit.loadData(shouldFail: true);
        expect(cubit.state.isLoading, isTrue);
        await failFuture;
        expect(cubit.state.isFailure, isTrue);
        expect(cubit.state.errorMessage, equals('Failed to load'));

        await cubit.close();
      },
    );

    test('UiState pattern matching when and map', () {
      const initial = UiState<int>.initial();
      expect(
        initial.when(
          initial: () => 'INIT',
          loading: () => 'LOAD',
          success: (d) => 'DATA: $d',
          failure: (e) => 'ERR: $e',
        ),
        equals('INIT'),
      );

      const success = UiState<int>.success(100);
      expect(success.dataOrNull, equals(100));
      expect(success.errorMessage, isNull);

      const failure = UiState<int>.failure('Network Down');
      expect(failure.errorMessage, equals('Network Down'));
    });
  });

  group('FpEventTransformers & BaseBloc', () {
    test('Debounce transformer groups rapid events', () async {
      final bloc = SearchBloc();

      bloc.add(const SearchQueryEvent('f'));
      bloc.add(const SearchQueryEvent('fl'));
      bloc.add(const SearchQueryEvent('flu'));
      bloc.add(const SearchQueryEvent('flutt'));
      bloc.add(const SearchQueryEvent('flutter'));

      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Due to debounce, only the latest event in the burst is processed
      expect(bloc.state.length, equals(1));
      expect(bloc.state.last, equals('flutter'));

      await bloc.close();
    });
  });

  group('AppEvent Bus (AppEventCubit & AppEventListener)', () {
    test('AppEventCubit notifies listeners of global cross-feature events', () {
      final cubit = AppEventCubit();
      expect(cubit.state, isNull);

      cubit.notifyChanged(const SampleAppEvent('UserLoggedIn'));
      expect(cubit.state?.event, isA<SampleAppEvent>());
      expect(
        (cubit.state?.event as SampleAppEvent).payload,
        equals('UserLoggedIn'),
      );

      unawaited(cubit.close());
    });

    testWidgets('AppEventListener receives events and handles callback', (
      tester,
    ) async {
      final eventCubit = AppEventCubit();
      String? receivedEventPayload;

      await tester.pumpWidget(
        BlocProvider.value(
          value: eventCubit,
          child: MaterialApp(
            home: AppEventListener(
              events: [
                OnEvent<SampleAppEvent>((ctx, event) {
                  receivedEventPayload = event.payload;
                }),
              ],
              child: const Text('Child View'),
            ),
          ),
        ),
      );

      expect(find.text('Child View'), findsOneWidget);
      expect(receivedEventPayload, isNull);

      eventCubit.notifyChanged(const SampleAppEvent('GlobalSignal'));
      await tester.pump();

      expect(receivedEventPayload, equals('GlobalSignal'));

      await eventCubit.close();
    });
  });

  group('ThemeCubit & LocaleCubit Persistence', () {
    test('ThemeCubit toggles mode and persists to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final themeCubit = ThemeCubit(prefs);
      expect(themeCubit.state, equals(ThemeMode.system));

      await themeCubit.setThemeMode(ThemeMode.dark);
      expect(themeCubit.state, equals(ThemeMode.dark));
      expect(themeCubit.isDarkMode, isTrue);
      expect(
        prefs.getInt('application_theme_mode_index'),
        equals(ThemeMode.dark.index),
      );

      await themeCubit.toggleTheme();
      expect(themeCubit.state, equals(ThemeMode.light));
      expect(themeCubit.isLightMode, isTrue);

      await themeCubit.close();
    });

    test('LocaleCubit changes locale, identifies RTL, and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final localeCubit = LocaleCubit(prefs);
      expect(localeCubit.state, equals(const Locale('en', 'US')));
      expect(localeCubit.isRtl, isFalse);

      await localeCubit.setLocaleByCode('ne', 'NP');
      expect(localeCubit.state, equals(const Locale('ne', 'NP')));
      expect(prefs.getString('application_language_code'), equals('ne'));
      expect(prefs.getString('application_country_code'), equals('NP'));

      // RTL test (Arabic)
      await localeCubit.setLocaleByCode('ar');
      expect(localeCubit.isRtl, isTrue);

      await localeCubit.close();
    });
  });
}
