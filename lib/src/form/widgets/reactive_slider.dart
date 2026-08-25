import 'package:flutter/material.dart';
import '../field.dart';

/// A reactive slider that binds to a [Field<double>].
///
/// Automatically infers header label from [field.labelText] and displays current value and validation errors.
class ReactiveSlider extends StatelessWidget {
  final Field<double> field;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String Function(double)? valueFormatter;
  final bool enabled;

  const ReactiveSlider({
    super.key,
    required this.field,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.valueFormatter,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = label ?? field.labelText;
    final formattedValue = valueFormatter != null
        ? valueFormatter!(field.value)
        : field.value.toStringAsFixed(divisions != null ? 0 : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (effectiveLabel != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                effectiveLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                formattedValue,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        Slider(
          value: field.value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          label: formattedValue,
          onChanged: enabled ? onChanged : null,
        ),
        if (field.hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              field.error!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
