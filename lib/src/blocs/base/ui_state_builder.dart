import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui_state.dart';

/// A reactive widget that listens to a [StateStreamable] emitting [UiState<T>]
/// and automatically builds the corresponding UI for initial, loading, success, and failure states.
///
/// ### Usage:
/// ```dart
/// UiStateBuilder<ProductListCubit, List<Product>>(
///   bloc: productListCubit,
///   onSuccess: (context, products) => ListView.builder(...),
///   onLoading: (context) => const Center(child: CircularProgressIndicator()),
///   onFailure: (context, error) => Center(child: Text(error)),
/// )
/// ```
class UiStateBuilder<B extends StateStreamable<UiState<T>>, T>
    extends StatelessWidget {
  final B? bloc;
  final Widget Function(BuildContext context, T data) onSuccess;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context, String message)? onFailure;
  final Widget Function(BuildContext context)? onInitial;
  final Widget Function(BuildContext context, String? message)? onEmpty;
  final bool Function(T data)? isEmpty;

  const UiStateBuilder({
    super.key,
    this.bloc,
    required this.onSuccess,
    this.onLoading,
    this.onFailure,
    this.onInitial,
    this.onEmpty,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, UiState<T>>(
      bloc: bloc,
      builder: (context, state) {
        return switch (state) {
          UiInitial<T>() => onInitial?.call(context) ?? const SizedBox.shrink(),
          UiLoading<T>() =>
            onLoading?.call(context) ??
                const Center(child: CircularProgressIndicator()),
          UiFailure<T>(:final message) =>
            onFailure?.call(context, message) ??
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(message, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
          UiSuccess<T>(:final data) => _buildSuccess(context, data),
        };
      },
    );
  }

  Widget _buildSuccess(BuildContext context, T data) {
    if (isEmpty != null && isEmpty!(data)) {
      return onEmpty?.call(context, null) ??
          const Center(child: Text('No data available'));
    }
    if (data is Iterable && data.isEmpty) {
      return onEmpty?.call(context, null) ??
          const Center(child: Text('No items found'));
    }
    return onSuccess(context, data);
  }
}
