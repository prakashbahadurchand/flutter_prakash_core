import 'package:flutter/material.dart';

class DashboardFeedItemModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const DashboardFeedItemModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}
