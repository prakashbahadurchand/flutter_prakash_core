import 'package:flutter/material.dart';
import '../field.dart';

/// A reactive checkbox that binds to a [Field<bool>].
///
/// Shows validation errors when the field is dirty and auto-infers [title] from [Field.labelText].
class ReactiveCheckbox extends StatelessWidget {
  final Field<bool> field;
  final String? title;
  final ValueChanged<bool?> onChanged;
  final String? subtitle;

  const ReactiveCheckbox({
    super.key,
    required this.field,
    required this.onChanged,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTitle = title ?? field.labelText ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: field.value,
          onChanged: onChanged,
          title: Text(effectiveTitle),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: theme.colorScheme.primary,
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
