import 'package:flutter/material.dart';
import '../field.dart';

/// A reactive date picker that binds to a [Field<DateTime?>].
///
/// Shows validation errors when the field is dirty and auto-infers [label] from [Field.labelText].
class ReactiveDatePicker extends StatelessWidget {
  final Field<DateTime?> field;
  final ValueChanged<DateTime?> onChanged;
  final String? label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const ReactiveDatePicker({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = label ?? field.labelText ?? 'Select Date';
    final hasValue = field.value != null;
    final displayText = hasValue
        ? field.value!.toString().split(' ')[0]
        : effectiveLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: field.value ?? DateTime.now(),
              firstDate: firstDate ?? DateTime(2000),
              lastDate: lastDate ?? DateTime(2100),
            );
            if (date != null) onChanged(date);
          },
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: hasValue ? effectiveLabel : null,
              hintText: hasValue ? null : effectiveLabel,
              errorText: field.hasError ? field.error : null,
              suffixIcon: Icon(
                Icons.calendar_month_outlined,
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
