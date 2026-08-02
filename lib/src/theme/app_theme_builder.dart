import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFB00020);
}

/// Atomic design tokens: spacing, radii, elevation. Centralized so consuming
/// apps can scale the whole design system uniformly.
class AppSpacing {
  const AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadii {
  const AppRadii._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double full = 999;
}

class AppElevation {
  const AppElevation._();
  static const double flat = 0;
  static const double low = 1;
  static const double medium = 3;
  static const double high = 8;
}

/// Centralized Google Fonts type-scale mapping.
class AppTypography {
  const AppTypography._();

  static TextTheme build({Brightness brightness = Brightness.light}) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    return GoogleFonts.interTextTheme(base);
  }
}

class AppThemeBuilder {
  static ThemeData buildLightTheme() {
    return _build(Brightness.light);
  }

  static ThemeData buildDarkTheme() {
    return _build(Brightness.dark);
  }

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTypography.build(brightness: brightness),
      cardTheme: CardThemeData(
        elevation: AppElevation.low,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
      ),
    );
  }
}
