import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../form_cubit.dart';

/// A reactive form listener widget that automatically handles success/failure
/// snackbars and callbacks without repetitive BlocListener boilerplate.
class ReactiveFormListener<C extends FormCubit<S>, S extends FormState>
    extends StatelessWidget {
  final Widget child;
  final String? successMessage;
  final void Function(BuildContext context, S state)? onSuccess;
  final void Function(BuildContext context, String errorMessage)? onFailure;

  const ReactiveFormListener({
    super.key,
    required this.child,
    this.successMessage,
    this.onSuccess,
    this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<C, S>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          if (successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(successMessage!),
                  ],
                ),
                backgroundColor: Colors.green.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          onSuccess?.call(context, state);
        } else if (state.status.isFailure) {
          final errorMsg = state.status.failureMessage ?? 'Operation failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(errorMsg)),
                ],
              ),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          onFailure?.call(context, errorMsg);
        }
      },
      child: child,
    );
  }
}
