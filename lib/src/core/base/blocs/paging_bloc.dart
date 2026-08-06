import 'dart:async';
import 'package:equatable/equatable.dart';
import '../../network/failures.dart';
import '../../network/result.dart';
import 'base_cubit.dart';

/// Immutable State representation for paginated lists across Flutter Prakash applications.
class PagingState<T> extends Equatable {
  final List<T> items;
  final int page;
  final int pageSize;
  final bool hasNextPage;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool isRefreshing;
  final Failure? failure;

  const PagingState({
    this.items = const [],
    this.page = 1,
    this.pageSize = 20,
    this.hasNextPage = true,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.failure,
  });

  bool get isEmpty => !isLoadingInitial && items.isEmpty;
  bool get isSuccess => !isLoadingInitial && items.isNotEmpty && failure == null;
  bool get hasError => failure != null;

  PagingState<T> copyWith({
    List<T>? items,
    int? page,
    int? pageSize,
    bool? hasNextPage,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? isRefreshing,
    Failure? failure,
  }) {
    return PagingState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
        items,
        page,
        pageSize,
        hasNextPage,
        isLoadingInitial,
        isLoadingMore,
        isRefreshing,
        failure,
      ];
}

/// Abstract Base Paging Cubit for paginated list operations.
abstract class BasePagingCubit<T> extends BaseCubit<PagingState<T>> {
  BasePagingCubit({int initialPage = 1, int pageSize = 20})
      : super(PagingState<T>(page: initialPage, pageSize: pageSize));

  /// User-implemented query method to fetch items for a specific [page] and [pageSize].
  Future<Result<List<T>>> fetchPage(int page, int pageSize);

  /// Fetch initial page of items.
  Future<void> fetchInitial() async {
    safeEmit(state.copyWith(isLoadingInitial: true, failure: null));
    final result = await fetchPage(1, state.pageSize);

    result.when(
      success: (newItems) {
        safeEmit(
          state.copyWith(
            items: newItems,
            page: 1,
            hasNextPage: newItems.length >= state.pageSize,
            isLoadingInitial: false,
          ),
        );
      },
      error: (failure) {
        safeEmit(
          state.copyWith(
            isLoadingInitial: false,
            failure: failure,
          ),
        );
      },
    );
  }

  /// Pull-to-refresh paginated data.
  Future<void> refresh() async {
    if (state.isRefreshing) return;
    safeEmit(state.copyWith(isRefreshing: true, failure: null));
    final result = await fetchPage(1, state.pageSize);

    result.when(
      success: (newItems) {
        safeEmit(
          state.copyWith(
            items: newItems,
            page: 1,
            hasNextPage: newItems.length >= state.pageSize,
            isRefreshing: false,
          ),
        );
      },
      error: (failure) {
        safeEmit(
          state.copyWith(
            isRefreshing: false,
            failure: failure,
          ),
        );
      },
    );
  }

  /// Fetch next page of items.
  Future<void> fetchNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage || state.isLoadingInitial) {
      return;
    }

    safeEmit(state.copyWith(isLoadingMore: true, failure: null));
    final nextPage = state.page + 1;
    final result = await fetchPage(nextPage, state.pageSize);

    result.when(
      success: (newItems) {
        safeEmit(
          state.copyWith(
            items: [...state.items, ...newItems],
            page: nextPage,
            hasNextPage: newItems.length >= state.pageSize,
            isLoadingMore: false,
          ),
        );
      },
      error: (failure) {
        safeEmit(
          state.copyWith(
            isLoadingMore: false,
            failure: failure,
          ),
        );
      },
    );
  }

  /// In-memory item insertion.
  void insertItem(T item, {int index = 0}) {
    final updatedList = List<T>.from(state.items)..insert(index, item);
    safeEmit(state.copyWith(items: updatedList));
  }

  /// In-memory item update matching [predicate].
  void updateItem(bool Function(T item) predicate, T Function(T current) update) {
    final updatedList = state.items.map((item) {
      return predicate(item) ? update(item) : item;
    }).toList();
    safeEmit(state.copyWith(items: updatedList));
  }

  /// In-memory item removal matching [predicate].
  void removeItem(bool Function(T item) predicate) {
    final updatedList = state.items.where((item) => !predicate(item)).toList();
    safeEmit(state.copyWith(items: updatedList));
  }

  /// Clears any active failure error state.
  void clearError() {
    safeEmit(PagingState<T>(
      items: state.items,
      page: state.page,
      pageSize: state.pageSize,
      hasNextPage: state.hasNextPage,
      isLoadingInitial: state.isLoadingInitial,
      isLoadingMore: state.isLoadingMore,
      isRefreshing: state.isRefreshing,
      failure: null,
    ));
  }
}

