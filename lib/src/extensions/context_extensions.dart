import 'package:flutter/material.dart';

/// Ergonomic UI & theme convenience extensions on [BuildContext].
extension ContextExtensions on BuildContext {
  /// Quick access to [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Quick access to [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width in logical pixels.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height in logical pixels.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Whether current theme is dark mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Whether current theme is light mode.
  bool get isLightMode => !isDarkMode;

  // Text Theme Shortcuts
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;

  // Color Scheme Shortcuts
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color? get primary => colorScheme.primary;
  Color? get onPrimary => colorScheme.onPrimary;
  Color? get primaryContainer => colorScheme.primaryContainer;
  Color? get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color? get secondary => colorScheme.secondary;
  Color? get onSecondary => colorScheme.onSecondary;
  Color? get secondaryContainer => colorScheme.secondaryContainer;
  Color? get onSecondaryContainer => colorScheme.onSecondaryContainer;
  Color? get background => colorScheme.surface;
  Color? get onBackground => colorScheme.onSurface;

  void mountedAction(void Function() action) => mounted ? action() : null;

  void hideKeyboard() => FocusScope.of(this).unfocus();

  Color clr(Color light, Color dark) => isLightMode ? light : dark;

  String txt(String english, String hindi, String nepali) {
    final locale = Localizations.localeOf(this).languageCode;

    switch (locale) {
      case 'hi':
        return hindi;
      case 'ne':
        return nepali;
      case 'en':
      default:
        return english;
    }
  }
}
