import 'package:flutter/material.dart';
import '../field.dart';

/// An option item for [ReactiveRadioGroup].
class RadioOption<T> {
  final T value;
  final String title;
  final String? subtitle;
  final Widget? secondary;

  const RadioOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.secondary,
  });
}

/// A reactive radio group that binds to a [Field<T?>] or [Field<T>].
///
/// Automatically infers the header label from [Field.labelText] and displays validation errors.
class ReactiveRadioGroup<T> extends StatelessWidget {
  final Field<T> field;
  final List<RadioOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? label;
  final Axis direction;
  final bool enabled;

  const ReactiveRadioGroup({
    super.key,
    required this.field,
    required this.options,
    required this.onChanged,
    this.label,
    this.direction = Axis.vertical,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = label ?? field.labelText;

    Widget content;
    if (direction == Axis.vertical) {
      content = Column(
        children: options.map((opt) {
          final isSelected = field.value == opt.value;
          return InkWell(
            onTap: enabled ? () => onChanged(opt.value) : null,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Radio<T>(
                    value: opt.value,
                    // ignore: deprecated_member_use
                    groupValue: field.value,
                    // ignore: deprecated_member_use
                    onChanged: enabled ? onChanged : null,
                    activeColor: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  if (opt.secondary != null) ...[
                    opt.secondary!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        if (opt.subtitle != null)
                          Text(
                            opt.subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else {
      content = Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((opt) {
          final isSelected = field.value == opt.value;
          return ChoiceChip(
            label: Text(opt.title),
            selected: isSelected,
            onSelected: enabled ? (_) => onChanged(opt.value) : null,
            selectedColor: theme.colorScheme.primaryContainer,
          );
        }).toList(),
      );
    }

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
          const SizedBox(height: 4),
        ],
        content,
        if (field.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              field.error!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
