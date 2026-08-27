import 'package:flutter/material.dart';
import 'package:flutter_prakash_core_example/config/config.dart';

class SplashLoadingBar extends StatelessWidget {
  const SplashLoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          minHeight: 4,
          backgroundColor: (isDark ? Colors.white : AppPalette.primaryDark)
              .withValues(alpha: 0.15),
          valueColor: const AlwaysStoppedAnimation<Color>(AppPalette.primary),
        ),
      ),
    );
  }
}
