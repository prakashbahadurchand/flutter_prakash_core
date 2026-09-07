import 'dart:async';

import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../form_cubit.dart';

/// A reactive submission button that automatically binds to a [FormCubit],
/// showing a progress indicator during [BlocStatus.loading] and triggering
/// form submission on tap.
class ReactiveFormButton<C extends FormCubit<S>, S extends FormState>
    extends StatelessWidget {
  final String? label;
  final Widget? child;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool requireValid;

  const ReactiveFormButton({
    super.key,
    this.label,
    this.child,
    this.icon,
    this.onPressed,
    this.style,
    this.requireValid = false,
  }) : assert(
         label != null || child != null,
         'Either label or child must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
      builder: (context, state) {
        final isLoading = state.status.isLoading;
        final isSubmittable =
            !isLoading && (!requireValid || state.isFormValid);

        final submitAction = isSubmittable
            ? () {
                if (onPressed != null) {
                  onPressed!();
                } else {
                  unawaited(context.read<C>().submit());
                }
              }
            : null;

        final effectiveChild = child ?? Text(label ?? '');

        if (icon != null) {
          return FilledButton.icon(
            onPressed: submitAction,
            style: style,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, size: 20),
            label: effectiveChild,
          );
        }

        return FilledButton(
          onPressed: submitAction,
          style: style,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : effectiveChild,
        );
      },
    );
  }
}
