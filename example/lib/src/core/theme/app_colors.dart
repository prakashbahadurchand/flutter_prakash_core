import 'package:flutter/material.dart';

class AppPalette {
  // Brand Primary (Indigo)
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFC7D2FE);
  static const Color primaryBgLight = Color(0xFFEEF2FF);
  static const Color primaryBgHover = Color(0xFFE0E7FF);

  // Secondary (Violet / Purple)
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFF6D28D9);
  static const Color purple = Color(0xFF9333EA);

  // Blue
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueDark = Color(0xFF1D4ED8);

  // Success (Emerald)
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF047857);

  // Warning (Amber)
  static const Color warning = Color(0xFFF59E0B);

  // Error (Red)
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);

  // Info (Cyan)
  static const Color info = Color(0xFF06B6D4);

  // Pink
  static const Color pink = Color(0xFFEC4899);

  // Slate / Neutrals
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Helper getters for common dark/light mode switches
  static Color surface(bool isDark) => isDark ? slate800 : Colors.white;
  static Color background(bool isDark) => isDark ? slate900 : slate50;
  static Color textPrimary(bool isDark) => isDark ? slate50 : slate900;
  static Color textSecondary(bool isDark) => isDark ? slate300 : slate600;
}
