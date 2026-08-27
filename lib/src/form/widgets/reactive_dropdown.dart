import 'package:flutter/material.dart';
import '../field.dart';

/// A reactive dropdown that binds to a [Field<T?>].
///
/// Shows validation errors when the field is dirty and auto-infers [label] from [Field.labelText].
class ReactiveDropdown<T> extends StatelessWidget {
  final Field<T?> field;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? label;
  final String? hintText;
  final bool enabled;

  const ReactiveDropdown({
    super.key,
    required this.field,
    required this.items,
    required this.onChanged,
    this.label,
    this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = label ?? field.labelText;
    final effectiveHint =
        hintText ??
        field.hintText ??
        (field.labelText != null
            ? 'Select ${field.labelText!.toLowerCase()}'
            : null);

    return DropdownButtonFormField<T>(
      initialValue: field.value,
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: effectiveLabel,
        hintText: effectiveHint,
        errorText: field.hasError ? field.error : null,
      ),
    );
  }
}
