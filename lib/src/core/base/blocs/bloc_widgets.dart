import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/failures.dart';
import '../../widgets/toast_overlay.dart';
import 'base_bloc.dart';
import 'base_cubit.dart';
import 'paging_bloc.dart';
import 'ui_effect.dart';
import 'ui_state.dart';

/// Flutter widget that renders UI based on [UiState<T>].
///
/// Eliminates boilerplate switch statements for initial, loading, success, failure, and empty states.
class UiStateBuilder<B extends StateStreamable<UiState<T>>, T>
    extends StatelessWidget {
  final B? bloc;
  final Widget Function(BuildContext context, T data) onSuccess;
  final Widget Function(BuildContext context, double? progress, String? message)?
      onLoading;
  final Widget Function(BuildContext context, Failure failure)? onError;
  final Widget Function(BuildContext context)? onInitial;
  final Widget Function(BuildContext context, String? message)? onEmpty;

  const UiStateBuilder({
    super.key,
    this.bloc,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onInitial,
    this.onEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, UiState<T>>(
      bloc: bloc,
      builder: (context, state) {
        return state.when(
          initial: () =>
              onInitial != null
                  ? onInitial!(context)
                  : const SizedBox.shrink(),
          loading: (progress, message) =>
              onLoading != null
                  ? onLoading!(context, progress, message)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          if (message != null) ...[
                            const SizedBox(height: 12),
                            Text(message, style: const TextStyle(fontSize: 14)),
                          ],
                        ],
                      ),
                    ),
          success: (data) => onSuccess(context, data),
          failure: (failure, previousData) =>
              onError != null
                  ? onError!(context, failure)
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              failure.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
          empty: (message) =>
              onEmpty != null
                  ? onEmpty!(context, message)
                  : Center(
                      child: Text(
                        message ?? 'No data found',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
        );
      },
    );
  }
}

/// Specialized listener widget that listens to single-shot [UiEffect] streams
/// emitted by [BaseBloc] or [BaseCubit].
class PrakashEffectListener<B extends StateStreamable<S>, S>
    extends StatefulWidget {
  final Stream<UiEffect> effectStream;
  final Widget child;
  final void Function(BuildContext context, UiEffect effect)? onEffect;

  const PrakashEffectListener({
    super.key,
    required this.effectStream,
    required this.child,
    this.onEffect,
  });

  /// Factory constructor when B extends [BaseBloc].
  static PrakashEffectListener fromBloc<
      B extends BaseBloc<dynamic, S>, S>({
    Key? key,
    required B bloc,
    required Widget child,
    void Function(BuildContext context, UiEffect effect)? onEffect,
  }) {
    return PrakashEffectListener<B, S>(
      key: key,
      effectStream: bloc.effectStream,
      onEffect: onEffect,
      child: child,
    );
  }

  /// Factory constructor when B extends [BaseCubit].
  static PrakashEffectListener fromCubit<
      B extends BaseCubit<S>, S>({
    Key? key,
    required B cubit,
    required Widget child,
    void Function(BuildContext context, UiEffect effect)? onEffect,
  }) {
    return PrakashEffectListener<B, S>(
      key: key,
      effectStream: cubit.effectStream,
      onEffect: onEffect,
      child: child,
    );
  }

  @override
  State<PrakashEffectListener<B, S>> createState() =>
      _PrakashEffectListenerState<B, S>();
}

class _PrakashEffectListenerState<B extends StateStreamable<S>, S>
    extends State<PrakashEffectListener<B, S>> {
  StreamSubscription<UiEffect>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant PrakashEffectListener<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.effectStream != widget.effectStream) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = widget.effectStream.listen((effect) {
      if (!mounted) return;

      // Handle standard effect defaults
      if (effect is ShowToastEffect) {
        if (effect.isError) {
          Toast.error(
            effect.message,
            duration: effect.duration ?? const Duration(seconds: 4),
          );
        } else {
          Toast.info(
            effect.message,
            duration: effect.duration ?? const Duration(seconds: 3),
          );
        }
      } else if (effect is ShowSnackBarEffect) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(effect.message),
            backgroundColor: effect.isError ? Colors.red : null,
            action: effect.actionLabel != null && effect.onAction != null
                ? SnackBarAction(
                    label: effect.actionLabel!,
                    onPressed: effect.onAction!,
                  )
                : null,
          ),
        );
      } else if (effect is NavigateToEffect) {
        if (effect.isReplacement) {
          Navigator.of(context).pushReplacementNamed(
            effect.path,
            arguments: effect.arguments,
          );
        } else {
          Navigator.of(context).pushNamed(
            effect.path,
            arguments: effect.arguments,
          );
        }
      } else if (effect is PopRouteEffect) {
        Navigator.of(context).pop(effect.result);
      } else if (effect is ShowDialogEffect) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(effect.title),
            content: Text(effect.message),
            actions: [
              if (effect.cancelLabel != null)
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(effect.cancelLabel!),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  effect.onConfirm?.call();
                },
                child: Text(effect.confirmLabel ?? 'OK'),
              ),
            ],
          ),
        );
      }

      // Delegate custom effects or user override
      widget.onEffect?.call(context, effect);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Ready-to-use Paginated ListView builder for [BasePagingCubit].
class PagingListView<B extends BasePagingCubit<T>, T>
    extends StatefulWidget {
  final B cubit;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? emptyWidget;
  final Widget Function(BuildContext context, Failure failure)? errorWidget;
  final Widget? loadingWidget;
  final EdgeInsetsGeometry padding;

  const PagingListView({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    this.emptyWidget,
    this.errorWidget,
    this.loadingWidget,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<PagingListView<B, T>> createState() => _PagingListViewState<B, T>();
}

class _PagingListViewState<B extends BasePagingCubit<T>, T>
    extends State<PagingListView<B, T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.cubit.fetchInitial();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.cubit.fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, PagingState<T>>(
      bloc: widget.cubit,
      builder: (context, state) {
        if (state.isLoadingInitial) {
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        if (state.hasError && state.items.isEmpty) {
          return widget.errorWidget != null
              ? widget.errorWidget!(context, state.failure!)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.failure?.message ?? 'Failed to load'),
                      ElevatedButton(
                        onPressed: () => widget.cubit.fetchInitial(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
        }

        if (state.isEmpty) {
          return widget.emptyWidget ??
              const Center(child: Text('No items found'));
        }

        return RefreshIndicator(
          onRefresh: () => widget.cubit.refresh(),
          child: ListView.builder(
            controller: _scrollController,
            padding: widget.padding,
            itemCount: state.items.length + (state.hasNextPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
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
