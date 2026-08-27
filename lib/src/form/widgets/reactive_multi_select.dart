import 'package:flutter/material.dart';
import '../field.dart';

/// An option item for [ReactiveMultiSelect].
class MultiSelectOption<T> {
  final T value;
  final String label;
  final Widget? avatar;

  const MultiSelectOption({
    required this.value,
    required this.label,
    this.avatar,
  });
}

/// A reactive multi-select chip group that binds to a [Field<List<T>>].
///
/// Automatically infers header label from [Field.labelText] and displays validation errors.
class ReactiveMultiSelect<T> extends StatelessWidget {
  final Field<List<T>> field;
  final List<MultiSelectOption<T>> options;
  final ValueChanged<List<T>> onChanged;
  final String? label;
  final bool enabled;

  const ReactiveMultiSelect({
    super.key,
    required this.field,
    required this.options,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = label ?? field.labelText;
    final currentValues = field.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (effectiveLabel != null) ...[
          Text(
            effectiveLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = currentValues.contains(opt.value);
            return FilterChip(
              avatar: opt.avatar,
              label: Text(opt.label),
              selected: isSelected,
              onSelected: enabled
                  ? (selected) {
                      final updated = List<T>.from(currentValues);
                      if (selected) {
                        updated.add(opt.value);
                      } else {
                        updated.remove(opt.value);
                      }
                      onChanged(updated);
                    }
                  : null,
            );
          }).toList(),
        ),
        if (field.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              field.error!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
