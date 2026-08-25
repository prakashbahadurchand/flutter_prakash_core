import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../form_cubit.dart';

/// A reactive submission button that automatically binds to a [FormCubit],
/// showing a progress indicator during [BlocStatus.loading] and triggering
/// form submission on tap.
class ReactiveFormButton<C extends FormCubit<S>, S extends FormState>
    extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  const ReactiveFormButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
      builder: (context, state) {
        final isLoading = state.status.isLoading;

        final submitAction = isLoading
            ? null
            : () {
                if (onPressed != null) {
                  onPressed!();
                } else {
                  context.read<C>().submit();
                }
              };

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
            label: Text(label),
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
              : Text(label),
        );
      },
    );
  }
}
