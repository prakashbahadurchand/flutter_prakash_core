import 'package:flutter/material.dart';

/// Ergonomic UI & theme convenience extensions on [BuildContext].
extension ContextExtensions on BuildContext {
  /// Quick access to [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Quick access to [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Quick access to [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

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
}
