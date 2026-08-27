import 'package:flutter_prakash_core/flutter_prakash_core.dart';

sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}

class SearchState {
  final String query;
  final UiState<List<String>> uiState;

  const SearchState({this.query = '', this.uiState = const UiState.initial()});

  SearchState copyWith({String? query, UiState<List<String>>? uiState}) {
    return SearchState(
      query: query ?? this.query,
      uiState: uiState ?? this.uiState,
    );
  }
}

@injectable
class SampleSearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<String> _mockFeatures = const [
    'BaseUiCubit (Loading, Success, Empty, Error)',
    'Formz Reactive Forms (Auto-Validation)',
    'Paging ListView (Infinite Scroll pagination)',
    'Debounced Search BLoC (300ms stream throttle)',
    'Multi-Level ANSI Colorful Logging',
    'GetIt & Injectable Dependency Injection',
    'AutoRoute Type-Safe Routing & Route Guards',
    'Google AdMob Ads & Smart Templates',
  ];

  SampleSearchBloc() : super(const SearchState()) {
    on<SearchQueryChangedEvent>(
      _onQueryChanged,
      transformer: PrakashEventTransformers.debounce(
        const Duration(milliseconds: 300),
      ),
    );

    on<ClearSearchEvent>((event, emit) {
      emit(const SearchState());
    });
  }

  Future<void> _onQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim().toLowerCase();
    if (query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(query: query, uiState: const UiState.loading()));

    await Future.delayed(const Duration(milliseconds: 300));

    final filtered = _mockFeatures
        .where((feature) => feature.toLowerCase().contains(query))
        .toList();

    emit(state.copyWith(uiState: UiState.success(filtered)));
  }
}
