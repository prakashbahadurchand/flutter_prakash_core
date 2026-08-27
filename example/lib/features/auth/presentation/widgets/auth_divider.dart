import 'package:flutter/material.dart';

class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, this.text = 'OR'});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor)),
      ],
    );
  }
}
