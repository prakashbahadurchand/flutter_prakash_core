import 'package:flutter/material.dart';
import '../field.dart';

/// A reactive segmented button that binds to a [Field<T>].
///
/// Automatically infers the header label from [Field.labelText] and displays validation errors.
class ReactiveSegmentedButton<T> extends StatelessWidget {
  final Field<T> field;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T> onSelectionChanged;
  final String? label;
  final bool multiSelectionEnabled;

  const ReactiveSegmentedButton({
    super.key,
    required this.field,
    required this.segments,
    required this.onSelectionChanged,
    this.label,
    this.multiSelectionEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = label ?? field.labelText;

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
        SegmentedButton<T>(
          segments: segments,
          selected: {field.value},
          onSelectionChanged: (newSelection) {
            if (newSelection.isNotEmpty) {
              onSelectionChanged(newSelection.first);
            }
          },
          multiSelectionEnabled: multiSelectionEnabled,
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
