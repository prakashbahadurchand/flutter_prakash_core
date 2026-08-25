import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'paginated_cubit.dart';

/// A reactive paginated sliver list widget for use inside [CustomScrollView].
class PaginatedSliverList<T, C extends PaginatedCubit<T, F>, F>
    extends StatelessWidget {
  final C cubit;
  final ItemWidgetBuilder<T> itemBuilder;
  final Widget? emptyIndicator;
  final Widget Function(BuildContext context, String error, VoidCallback retry)?
  errorIndicatorBuilder;

  const PaginatedSliverList({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    this.emptyIndicator,
    this.errorIndicatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<PagingState<int, T>>(
      valueListenable: cubit.pagingController,
      builder: (context, pagingState, _) {
        return PagedSliverList<int, T>(
          state: pagingState,
          fetchNextPage: cubit.pagingController.fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: itemBuilder,
            firstPageProgressIndicatorBuilder: (_) => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            newPageProgressIndicatorBuilder: (_) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
            noItemsFoundIndicatorBuilder: (_) =>
                emptyIndicator ??
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No items found',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
            firstPageErrorIndicatorBuilder: (ctx) =>
                errorIndicatorBuilder?.call(
                  ctx,
                  pagingState.error?.toString() ?? 'An error occurred',
                  cubit.retry,
                ) ??
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pagingState.error?.toString() ??
                              'Failed to load data',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: cubit.retry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }
}
