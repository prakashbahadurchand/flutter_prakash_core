import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'paginated_cubit.dart';
import 'paginated_state.dart';

/// A reactive, zero-boilerplate paginated grid widget that binds directly
/// to a [PaginatedCubit].
class PaginatedGridView<T, C extends PaginatedCubit<T, F>, F>
    extends StatelessWidget {
  final ItemWidgetBuilder<T> itemBuilder;
  final SliverGridDelegate gridDelegate;
  final bool showSearchBar;
  final String searchHint;
  final Widget? header;
  final Widget? emptyIndicator;
  final EdgeInsetsGeometry padding;

  const PaginatedGridView({
    super.key,
    required this.itemBuilder,
    required this.gridDelegate,
    this.showSearchBar = true,
    this.searchHint = 'Search...',
    this.header,
    this.emptyIndicator,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<C>();

    return BlocBuilder<C, PaginatedState<T, F>>(
      buildWhen: (prev, curr) =>
          prev.searchQuery != curr.searchQuery || prev.filter != curr.filter,
      builder: (context, state) {
        return Column(
          children: [
            if (showSearchBar)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: SearchBar(
                  hintText: searchHint,
                  leading: const Icon(Icons.search),
                  trailing: state.searchQuery.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => cubit.onSearchChanged(''),
                          ),
                        ]
                      : null,
                  onChanged: cubit.onSearchChanged,
                  elevation: const WidgetStatePropertyAll(0.5),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ?header,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => cubit.refresh(),
                child: ValueListenableBuilder<PagingState<int, T>>(
                  valueListenable: cubit.pagingController,
                  builder: (context, pagingState, _) {
                    return PagedGridView<int, T>(
                      state: pagingState,
                      fetchNextPage: cubit.pagingController.fetchNextPage,
                      gridDelegate: gridDelegate,
                      padding: padding,
                      builderDelegate: PagedChildBuilderDelegate<T>(
                        itemBuilder: itemBuilder,
                        firstPageProgressIndicatorBuilder: (_) =>
                            const Center(child: CircularProgressIndicator()),
                        newPageProgressIndicatorBuilder: (_) => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        ),
                        noItemsFoundIndicatorBuilder: (_) =>
                            emptyIndicator ??
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.grid_view_outlined,
                                      size: 64,
                                      color: theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No items found',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        firstPageErrorIndicatorBuilder: (_) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                pagingState.error?.toString() ??
                                    'Failed to load data',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: cubit.retry,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
