import 'package:flutter/material.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/models/onboarding_item_model.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final OnboardingItemModel item;

  const OnboardingSlideWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: item.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: item.gradient.first.withValues(alpha: 0.35),
                  blurRadius: 32,
                  spreadRadius: 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              item.icon,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: item.gradient.first.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.badge,
              style: TextStyle(
                color: item.gradient.first,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
