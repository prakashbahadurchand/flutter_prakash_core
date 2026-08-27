import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../form/bloc_status.dart';
import '../../network/result.dart';
import 'paginated_state.dart';

/// Base enterprise Paginated Cubit that integrates [PagingController] with BLoC state,
/// automated debounce search, dynamic filtering, pull-to-refresh, optimistic item mutations,
/// out-of-order race condition guards, Dio [CancelToken] aborts, and error retries.
abstract class PaginatedCubit<T, F> extends Cubit<PaginatedState<T, F>> {
  final int pageSize;
  final int firstPageKey;
  final Duration debounceDuration;

  late final PagingController<int, T> pagingController;
  Timer? _debounceTimer;
  CancelToken? _currentCancelToken;
  int _activeRequestId = 0;

  PaginatedCubit({
    this.pageSize = 20,
    this.firstPageKey = 1,
    this.debounceDuration = const Duration(milliseconds: 400),
    F? initialFilter,
  }) : super(PaginatedState.initial(initialFilter: initialFilter)) {
    pagingController = PagingController<int, T>(
      getNextPageKey: (state) =>
          state.items != null && state.items!.length >= pageSize
          ? (state.keys?.last ?? firstPageKey) + 1
          : null,
      fetchPage: (pageKey) => loadPage(pageKey),
    );
  }

  /// Abstract contract for subclasses to implement the actual data source call.
  /// Receives an optional [cancelToken] for aborting in-flight HTTP requests.
  Future<Result<List<T>>> fetchPageData({
    required int pageKey,
    required int pageSize,
    required String searchQuery,
    F? filter,
    CancelToken? cancelToken,
  });

  /// All items currently stored in the paging controller.
  List<T> get currentItems => pagingController.value.items ?? [];

  /// Triggered whenever the user types in the search field. Automatically debounced.
  void onSearchChanged(String query) {
    if (state.searchQuery == query) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, () {
      if (isClosed) return;
      emit(state.copyWith(searchQuery: query.trim(), totalLoaded: 0));
      refresh();
    });
  }

  /// Triggered whenever a filter parameter changes (e.g. status, category, date).
  void onFilterChanged(F? filter) {
    if (state.filter == filter) return;
    emit(state.copyWith(filter: filter, totalLoaded: 0));
    refresh();
  }

  /// Clears search query and resets filter to default.
  void resetFilters({F? defaultFilter}) {
    _debounceTimer?.cancel();
    emit(
      state.copyWith(searchQuery: '', filter: defaultFilter, totalLoaded: 0),
    );
    refresh();
  }

  /// Refreshes the paging controller, aborts in-flight requests, and resets to [firstPageKey].
  void refresh() {
    _abortInFlightRequest();
    if (!isClosed) {
      emit(state.copyWith(status: const BlocStatus.loading(), totalLoaded: 0));
    }
    pagingController.refresh();
  }

  /// Retries the last failed page request.
  void retry() {
    pagingController.fetchNextPage();
  }

  // ── In-Memory Optimistic UI Mutations ─────────────────────────────────────

  /// Inserts a newly created item into the list without requiring a full network refetch.
  void insertItem(T item, [int index = 0]) {
    final updated = List<T>.of(currentItems);
    if (index >= 0 && index <= updated.length) {
      updated.insert(index, item);
    } else {
      updated.add(item);
    }
    _syncItems(updated);
  }

  /// Updates an item in-place matching the [matcher] predicate.
  void updateItem(bool Function(T item) matcher, T updatedItem) {
    final updated = List<T>.of(currentItems);
    final idx = updated.indexWhere(matcher);
    if (idx != -1) {
      updated[idx] = updatedItem;
      _syncItems(updated);
    }
  }

  /// Removes an item in-place matching the [matcher] predicate.
  void removeItem(bool Function(T item) matcher) {
    final updated = List<T>.of(currentItems);
    final idx = updated.indexWhere(matcher);
    if (idx != -1) {
      updated.removeAt(idx);
      _syncItems(updated);
    }
  }

  void _syncItems(List<T> newItems) {
    final currentVal = pagingController.value;
    final key = currentVal.keys?.isNotEmpty == true
        ? currentVal.keys!.first
        : firstPageKey;
    pagingController.value = PagingState<int, T>(
      pages: [newItems],
      keys: [key],
      error: currentVal.error,
      hasNextPage: currentVal.hasNextPage,
    );
    if (!isClosed) {
      emit(state.copyWith(totalLoaded: newItems.length));
    }
  }

  // ── Page Loading & Concurrency Safety ────────────────────────────────────

  void _abortInFlightRequest() {
    _currentCancelToken?.cancel('Superseded by a new query or refresh action');
    _currentCancelToken = CancelToken();
    _activeRequestId++;
  }

  /// Loads the given [pageKey] and emits updated [PaginatedState].
  /// Guarantees out-of-order responses from stale requests are discarded.
  ///
  /// Returns items to [PagingController] which manages its own page/key state.
  /// Only [PaginatedState] (BLoC state) is mutated here for UI tracking.
  Future<List<T>> loadPage(int pageKey) async {
    // Capture current request ID — don't increment here since
    // _abortInFlightRequest() already manages the ID on refresh/search.
    final requestId = _activeRequestId;
    final cancelToken = CancelToken();
    _currentCancelToken = cancelToken;

    final result = await fetchPageData(
      pageKey: pageKey,
      pageSize: pageSize,
      searchQuery: state.searchQuery,
      filter: state.filter,
      cancelToken: cancelToken,
    );

    // If a newer search query or refresh was triggered, discard this stale response.
    if (requestId != _activeRequestId || isClosed) {
      return [];
    }

    return result.when(
      success: (items) {
        final isLast = items.length < pageSize;

        // Let PagingController manage its own pages/keys internally.
        // We only update our BLoC state for UI tracking purposes.
        final currentTotal =
            (pagingController.value.items?.length ?? 0) + items.length;

        if (!isClosed) {
          emit(
            state.copyWith(
              status: const BlocStatus.success(),
              totalLoaded: currentTotal,
              isLastPage: isLast,
            ),
          );
        }
        return items;
      },
      error: (appError) {
        // If the request was cancelled intentionally due to debounce/refresh, do not mark as failure.
        if (cancelToken.isCancelled) return <T>[];

        final errorMsg = appError.errorMessage;
        if (!isClosed) {
          emit(state.copyWith(status: BlocStatus.failure(errorMsg)));
        }
        throw Exception(errorMsg);
      },
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _currentCancelToken?.cancel('Cubit disposed');
    pagingController.dispose();
    return super.close();
  }
}
