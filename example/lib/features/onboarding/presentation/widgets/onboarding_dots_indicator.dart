import 'package:flutter/material.dart';
import 'package:flutter_prakash_core_example/config/config.dart';

class OnboardingDotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(right: 8),
          width: currentIndex == i ? 32 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentIndex == i
                ? AppPalette.primary
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
