import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../field.dart';

/// A reactive PIN/OTP verification code field that binds to a [Field<String>].
class ReactivePinCodeField extends StatefulWidget {
  final Field<String> field;
  final ValueChanged<String> onChanged;
  final int length;
  final String? label;
  final bool obscureText;
  final bool autoFocus;

  const ReactivePinCodeField({
    super.key,
    required this.field,
    required this.onChanged,
    this.length = 6,
    this.label,
    this.obscureText = false,
    this.autoFocus = false,
  });

  @override
  State<ReactivePinCodeField> createState() => _ReactivePinCodeFieldState();
}

class _ReactivePinCodeFieldState extends State<ReactivePinCodeField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ReactivePinCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.field.value != _controller.text) {
      _controller.text = widget.field.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabel = widget.label ?? widget.field.labelText;
    final currentValue = widget.field.value;

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
          const SizedBox(height: 12),
        ],
        Stack(
          children: [
            Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: widget.autoFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                onChanged: widget.onChanged,
              ),
            ),
            GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(widget.length, (index) {
                  final hasChar = index < currentValue.length;
                  final char = hasChar ? currentValue[index] : '';
                  final isFocused =
                      _focusNode.hasFocus && index == currentValue.length;

                  return Container(
                    width: 48,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: widget.field.hasError
                            ? theme.colorScheme.error
                            : isFocused
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                        width: isFocused || widget.field.hasError ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      widget.obscureText && hasChar ? '●' : char,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        if (widget.field.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              widget.field.error!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
