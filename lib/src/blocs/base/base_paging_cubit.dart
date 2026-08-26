import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/result.dart';
import '../../form/bloc_status.dart';

/// Lightweight base paging cubit for simple pagination use cases.
///
/// For advanced pagination with [PagingController], debounce search, filters,
/// optimistic mutations, and cancel tokens, use [PaginatedCubit] instead.
///
/// ### Usage:
/// ```dart
/// @injectable
/// class UserListCubit extends BasePagingCubit<User> {
///   final UserRepository _repo;
///   UserListCubit(this._repo) : super(pageSize: 20);
///
///   @override
///   Future<Result<List<User>>> fetchPage(int page, int pageSize) {
///     return _repo.getUsers(page: page, limit: pageSize);
///   }
/// }
/// ```
abstract class BasePagingCubit<T> extends Cubit<BasePagingState<T>> {
  final int pageSize;

  BasePagingCubit({this.pageSize = 20}) : super(const BasePagingState());

  /// Subclasses implement the actual data-fetching logic.
  Future<Result<List<T>>> fetchPage(int page, int pageSize);

  /// Loads the next page of data.
  Future<void> loadNextPage() async {
    if (state.isLastPage || state.status.isLoading) return;

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(status: const BlocStatus.loading()));

    final result = await fetchPage(nextPage, pageSize);
    result.when(
      success: (items) {
        final allItems = [...state.items, ...items];
        emit(
          state.copyWith(
            status: const BlocStatus.success(),
            items: allItems,
            currentPage: nextPage,
            isLastPage: items.length < pageSize,
          ),
        );
      },
      error: (failure) {
        emit(state.copyWith(status: BlocStatus.failure(failure.errorMessage)));
      },
    );
  }

  /// Refreshes from page 1, clearing all existing data.
  Future<void> refresh() async {
    emit(const BasePagingState());
    await loadNextPage();
  }

  /// Optimistically removes items matching [test] predicate.
  void removeItem(bool Function(T item) test) {
    final updated = state.items.where((item) => !test(item)).toList();
    emit(state.copyWith(items: updated));
  }

  /// Inserts [item] at [index] (default at beginning).
  void insertItem(T item, [int index = 0]) {
    final updated = List<T>.from(state.items)..insert(index, item);
    emit(state.copyWith(items: updated));
  }

  /// All currently loaded items.
  List<T> get currentItems => state.items;
  List<T> get items => state.items;
}

/// State for [BasePagingCubit].
class BasePagingState<T> {
  final BlocStatus status;
  final List<T> items;
  final int currentPage;
  final bool isLastPage;

  const BasePagingState({
    this.status = const BlocStatus.initial(),
    this.items = const [],
    this.currentPage = 0,
    this.isLastPage = false,
  });

  BasePagingState<T> copyWith({
    BlocStatus? status,
    List<T>? items,
    int? currentPage,
    bool? isLastPage,
  }) {
    return BasePagingState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasePagingState<T> &&
          status == other.status &&
          currentPage == other.currentPage &&
          isLastPage == other.isLastPage &&
          items.length == other.items.length;

  @override
  int get hashCode =>
      Object.hash(status, currentPage, isLastPage, items.length);
}
