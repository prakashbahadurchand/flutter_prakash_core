import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/config/themes/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light =>
      AppThemeBuilder.buildLightTheme(primaryColor: AppPalette.primary);

  static ThemeData get dark =>
      AppThemeBuilder.buildDarkTheme(primaryColor: AppPalette.primary);
}
