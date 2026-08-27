import 'package:flutter/material.dart';
import 'package:flutter_prakash_core_example/config/config.dart';

class AuthFooter extends StatelessWidget {
  final String prompt;
  final String actionLabel;
  final VoidCallback onAction;

  const AuthFooter({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prompt,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: AppPalette.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
