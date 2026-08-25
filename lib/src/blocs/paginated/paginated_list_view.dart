import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'paginated_cubit.dart';
import 'paginated_state.dart';

/// A reactive, zero-boilerplate paginated list widget that binds directly
/// to a [PaginatedCubit].
class PaginatedListView<T, C extends PaginatedCubit<T, F>, F>
    extends StatelessWidget {
  final ItemWidgetBuilder<T> itemBuilder;
  final bool showSearchBar;
  final String searchHint;
  final Widget? header;
  final Widget? emptyIndicator;
  final Widget Function(BuildContext context, String error, VoidCallback retry)?
  errorIndicatorBuilder;
  final EdgeInsetsGeometry padding;
  final Widget? separator;

  const PaginatedListView({
    super.key,
    required this.itemBuilder,
    this.showSearchBar = true,
    this.searchHint = 'Search...',
    this.header,
    this.emptyIndicator,
    this.errorIndicatorBuilder,
    this.padding = const EdgeInsets.all(16),
    this.separator,
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
                    if (separator != null) {
                      return PagedListView<int, T>.separated(
                        state: pagingState,
                        fetchNextPage: cubit.pagingController.fetchNextPage,
                        padding: padding,
                        separatorBuilder: (ctx, i) => separator!,
                        builderDelegate: _buildDelegate(
                          context,
                          theme,
                          cubit,
                          pagingState,
                        ),
                      );
                    }

                    return PagedListView<int, T>(
                      state: pagingState,
                      fetchNextPage: cubit.pagingController.fetchNextPage,
                      padding: padding,
                      builderDelegate: _buildDelegate(
                        context,
                        theme,
                        cubit,
                        pagingState,
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

  PagedChildBuilderDelegate<T> _buildDelegate(
    BuildContext context,
    ThemeData theme,
    C cubit,
    PagingState<int, T> pagingState,
  ) {
    return PagedChildBuilderDelegate<T>(
      itemBuilder: itemBuilder,
      firstPageProgressIndicatorBuilder: (_) =>
          const Center(child: CircularProgressIndicator()),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Try changing your search or clearing filters.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
                  Icon(
                    Icons.error_outline_rounded,
                    size: 56,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load content',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pagingState.error?.toString() ??
                        'Please check your internet connection.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: cubit.retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
