import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_paging_cubit.dart';

/// A reactive list view widget for [BasePagingCubit].
///
/// Automatically handles scroll pagination, loading spinners, empty states, and errors.
class PagingListView<C extends BasePagingCubit<T>, T> extends StatefulWidget {
  final C? cubit;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsetsGeometry padding;
  final Widget? emptyWidget;
  final Widget? separator;

  const PagingListView({
    super.key,
    this.cubit,
    required this.itemBuilder,
    this.padding = EdgeInsets.zero,
    this.emptyWidget,
    this.separator,
  });

  @override
  State<PagingListView<C, T>> createState() => _PagingListViewState<C, T>();
}

class _PagingListViewState<C extends BasePagingCubit<T>, T>
    extends State<PagingListView<C, T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    final cubit = widget.cubit ?? context.read<C>();
    if (cubit.state.items.isEmpty) {
      unawaited(cubit.loadNextPage());
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = widget.cubit ?? context.read<C>();
      unawaited(cubit.loadNextPage());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, BasePagingState<T>>(
      bloc: widget.cubit,
      builder: (context, state) {
        final cubit = widget.cubit ?? context.read<C>();

        if (state.items.isEmpty && state.status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.items.isEmpty && state.status.isFailure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.status.failureMessage ?? 'Error loading items'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: cubit.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.items.isEmpty) {
          return widget.emptyWidget ??
              const Center(child: Text('No items found'));
        }

        return RefreshIndicator(
          onRefresh: cubit.refresh,
          child: ListView.separated(
            controller: _scrollController,
            padding: widget.padding,
            itemCount: state.items.length + (state.isLastPage ? 0 : 1),
            separatorBuilder: (context, index) =>
                widget.separator ?? const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return widget.itemBuilder(context, state.items[index], index);
            },
          ),
        );
      },
    );
  }
}
