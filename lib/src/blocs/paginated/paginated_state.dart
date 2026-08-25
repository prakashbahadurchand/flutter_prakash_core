import 'package:freezed_annotation/freezed_annotation.dart';
import '../../form/bloc_status.dart';

part 'paginated_state.freezed.dart';

/// An immutable state model for paginated lists with search and filtering.
@freezed
abstract class PaginatedState<T, F> with _$PaginatedState<T, F> {
  const PaginatedState._();

  const factory PaginatedState({
    @Default('') String searchQuery,
    F? filter,
    @Default(BlocStatus.initial()) BlocStatus status,
    @Default(0) int totalLoaded,
    @Default(false) bool isLastPage,
  }) = _PaginatedState<T, F>;

  factory PaginatedState.initial({F? initialFilter}) => PaginatedState<T, F>(
    searchQuery: '',
    filter: initialFilter,
    status: const BlocStatus.initial(),
    totalLoaded: 0,
    isLastPage: false,
  );

  // ── State Convenience Getters ─────────────────────────────────────────────

  /// Whether the initial first page is currently loading.
  bool get isInitialLoading => status.isLoading && totalLoaded == 0;

  /// Whether a subsequent pull-to-refresh is currently ongoing.
  bool get isRefreshing => status.isLoading && totalLoaded > 0;

  /// Whether data has loaded successfully but returned zero items.
  bool get isEmpty => !status.isLoading && totalLoaded == 0;

  /// Whether the request resulted in a failure.
  bool get hasError => status.isFailure;

  /// The error message if [hasError] is true.
  String? get errorMessage => status.failureMessage;
}
