import 'package:flutter/material.dart';

class OnboardingItemModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final String badge;
  final List<Color> gradient;

  const OnboardingItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badge,
    required this.gradient,
  });
}
