import 'package:flutter/material.dart';

/// Supported application locales with display labels, country codes, and RTL metadata.
enum AppLocale {
  english(Locale('en'), 'English', '🇺🇸'),
  spanish(Locale('es'), 'Español', '🇪🇸'),
  nepali(Locale('ne'), 'नेपाली', '🇳🇵');

  final Locale locale;
  final String displayName;
  final String flag;

  const AppLocale(this.locale, this.displayName, this.flag);

  /// Finds matching [AppLocale] by language code, defaulting to English.
  static AppLocale fromLanguageCode(String? code) {
    return AppLocale.values.firstWhere(
      (l) => l.locale.languageCode == code,
      orElse: () => AppLocale.english,
    );
  }
}
