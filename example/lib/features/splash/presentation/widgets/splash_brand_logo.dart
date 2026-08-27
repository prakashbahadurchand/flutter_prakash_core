import 'package:flutter/material.dart';
import 'package:flutter_prakash_core_example/config/config.dart';

class SplashBrandLogo extends StatelessWidget {
  const SplashBrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppPalette.primary, AppPalette.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.primary.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.rocket_launch_rounded,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppPalette.primaryDark, AppPalette.purple],
          ).createShader(bounds),
          child: Text(
            AppConstants.appName,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appTagline,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDark ? AppPalette.slate300 : AppPalette.slate600,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
