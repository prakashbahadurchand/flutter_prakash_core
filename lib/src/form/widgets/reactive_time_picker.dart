import 'package:flutter/material.dart';
import '../field.dart';

/// A reactive time picker that binds to a [Field<TimeOfDay?>].
///
/// Automatically infers [Field.labelText] from [Field.labelText] and displays validation errors.
class ReactiveTimePicker extends StatelessWidget {
  final Field<TimeOfDay?> field;
  final ValueChanged<TimeOfDay?> onChanged;
  final String? label;

  const ReactiveTimePicker({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = label ?? field.labelText ?? 'Select Time';
    final hasValue = field.value != null;
    final displayText = hasValue
        ? field.value!.format(context)
        : effectiveLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: field.value ?? TimeOfDay.now(),
            );
            if (time != null) onChanged(time);
          },
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: hasValue ? effectiveLabel : null,
              hintText: hasValue ? null : effectiveLabel,
              errorText: field.hasError ? field.error : null,
              suffixIcon: Icon(
                Icons.access_time_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            child: Text(
              displayText,
              style: TextStyle(
                color: hasValue
                    ? theme.textTheme.bodyLarge?.color
                    : theme.hintColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
