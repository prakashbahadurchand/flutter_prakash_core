import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../field.dart';

/// A reactive text field that binds to a [Field<String>].
///
/// Automatically infers [labelText], [hintText], and [helperText] from [Field]
/// metadata, shows validation errors when dirty, and preserves controller state.
class ReactiveTextField extends StatefulWidget {
  final Field<String> field;
  final ValueChanged<String> onChanged;
  final String? label;
  final String? hintText;
  final String? helperText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  const ReactiveTextField({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.hintText,
    this.helperText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.inputFormatters,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
  });

  @override
  State<ReactiveTextField> createState() => _ReactiveTextFieldState();
}

class _ReactiveTextFieldState extends State<ReactiveTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value);
  }

  @override
  void didUpdateWidget(covariant ReactiveTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Programmatic external updates (e.g. form reset or cache hydration)
    if (widget.field.value != _controller.text) {
      final oldSelection = _controller.selection;
      _controller.text = widget.field.value;
      if (oldSelection.isValid &&
          oldSelection.end <= widget.field.value.length) {
        _controller.selection = oldSelection;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = widget.label ?? widget.field.labelText;
    final effectiveHint =
        widget.hintText ??
        widget.field.hintText ??
        (widget.field.labelText != null
            ? 'Enter ${widget.field.labelText!.toLowerCase()}'
            : null);
    final effectiveHelper = widget.helperText ?? widget.field.helperText;

    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: effectiveLabel,
        hintText: effectiveHint,
        helperText: effectiveHelper,
        errorText: widget.field.hasError ? widget.field.error : null,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
