import 'package:flutter/material.dart';
import '../field.dart';

/// A reactive switch that binds to a [Field<bool>].
///
/// Wraps [SwitchListTile] with consistent styling and optional subtitle.
/// Auto-infers [title] from [Field.labelText].
class ReactiveSwitch extends StatelessWidget {
  final Field<bool> field;
  final String? title;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  const ReactiveSwitch({
    super.key,
    required this.field,
    required this.onChanged,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = title ?? field.labelText ?? '';

    return SwitchListTile(
      title: Text(effectiveTitle),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: field.value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
