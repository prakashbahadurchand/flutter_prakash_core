import 'package:flutter_prakash/flutter_prakash.dart';

// Events
abstract class SearchEvent extends BaseEvent {
  const SearchEvent();
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}

// BLoC State wrapping UiState
class SearchState extends Equatable {
  final String query;
  final UiState<List<String>> resultState;

  const SearchState({
    this.query = '',
    this.resultState = const UiState.initial(),
  });

  SearchState copyWith({
    String? query,
    UiState<List<String>>? resultState,
  }) {
    return SearchState(
      query: query ?? this.query,
      resultState: resultState ?? this.resultState,
    );
  }

  @override
  List<Object?> get props => [query, resultState];
}

/// Sample Search BLoC demonstrating:
/// 1. RxDart Debounce event transformer (300ms)
/// 2. BaseBloc async execution with Dartz Either support
/// 3. UiState pattern matching
class SampleSearchBloc extends BaseBloc<SearchEvent, SearchState> {
  static const List<String> _mockDatabase = [
    'Flutter State Management',
    'Flutter Prakash Plugin',
    'Clean Architecture in Flutter',
    'RxDart Reactive Streams',
    'Formz Input Validation',
    'Dartz Either Functional Handling',
    'Injectable Dependency Injection',
    'AutoRoute Navigation Guards',
    'Freezed Immutable Models',
    'Enterprise Multi-App Engine',
  ];

  SampleSearchBloc() : super(const SearchState()) {
    on<SearchQueryChangedEvent>(
      _onQueryChanged,
      transformer: PrakashEventTransformers.debounce(
        const Duration(milliseconds: 300),
      ),
    );

    on<ClearSearchEvent>((event, emit) {
      safeEmit(const SearchState(), emit);
    });
  }

  Future<void> _onQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      safeEmit(const SearchState(), emit);
      return;
    }

    safeEmit(state.copyWith(query: query), emit);

    // Demonstrate handleEither with Dartz Either<Failure, List<String>>
    await handleEither<Failure, List<String>>(
      call: () async {
        await Future.delayed(const Duration(milliseconds: 400));
        final filtered = _mockDatabase
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (filtered.isEmpty) {
          return Left(const CacheFailure('No matching search results found.'));
        }

        return Right(filtered);
      },
      emit: emit,
      builder: (uiState) => state.copyWith(resultState: uiState),
    );
  }
}
