import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_locale.dart';

/// Cache key definition for local storage isolation
const String _localePreferenceKey = 'application_language_code';

/// Cache key definition for country code storage isolation
const String _localeCountryPreferenceKey = 'application_country_code';

/// An enterprise persistent [LocaleCubit] backed directly by [SharedPreferences].
///
/// Supports:
/// - Custom initial / default fallback locale (e.g. French, Japanese, etc.)
/// - Full `Locale(languageCode, countryCode)` resolution
/// - Custom list of `supportedLocales`
/// - Runtime dynamic addition of locales
/// - Persistence to [SharedPreferences]
@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences _preferences;
  final Locale defaultLocale;
  final List<Locale> supportedLocales;

  LocaleCubit(
    this._preferences, {
    this.defaultLocale = const Locale('en', 'US'),
    this.supportedLocales = const [
      Locale('en', 'US'),
      Locale('ne', 'NP'),
      Locale('es', 'ES'),
    ],
  }) : super(
         _getInitialLocale(
           _preferences,
           defaultLocale: defaultLocale,
           supportedLocales: supportedLocales,
         ),
       );

  /// Changes the current application locale and persists it to [SharedPreferences].
  Future<void> setLocale(Locale newLocale) async {
    if (state == newLocale) return;
    emit(newLocale);

    // Save language code
    await _preferences.setString(_localePreferenceKey, newLocale.languageCode);

    // Save country code if present, or remove if null
    if (newLocale.countryCode != null) {
      await _preferences.setString(
        _localeCountryPreferenceKey,
        newLocale.countryCode!,
      );
    } else {
      await _preferences.remove(_localeCountryPreferenceKey);
    }
  }

  /// Sets locale by language and optional country code (e.g. `setLocaleByCode('fr', 'FR')`).
  Future<void> setLocaleByCode(
    String languageCode, [
    String? countryCode,
  ]) async {
    await setLocale(Locale(languageCode, countryCode));
  }

  /// Sets locale using built-in [AppLocale] enum.
  Future<void> setAppLocale(AppLocale appLocale) async {
    await setLocale(appLocale.locale);
  }

  /// Checks if current language direction is Right-to-Left (e.g. Arabic, Hebrew, Urdu, Farsi).
  bool get isRtl {
    const rtlCodes = {'ar', 'he', 'fa', 'ur', 'ps', 'sd', 'ug', 'yi'};
    return rtlCodes.contains(state.languageCode.toLowerCase());
  }

  /// Resolves stored locale or falls back safely to [defaultLocale].
  static Locale _getInitialLocale(
    SharedPreferences prefs, {
    required Locale defaultLocale,
    required List<Locale> supportedLocales,
  }) {
    final langCode = prefs.getString(_localePreferenceKey);
    if (langCode == null || langCode.isEmpty) {
      return defaultLocale;
    }

    final countryCode = prefs.getString(_localeCountryPreferenceKey);

    // First try matching exact language + country
    if (countryCode != null && countryCode.isNotEmpty) {
      final exactMatch = supportedLocales.cast<Locale?>().firstWhere(
        (l) => l?.languageCode == langCode && l?.countryCode == countryCode,
        orElse: () => null,
      );
      if (exactMatch != null) return exactMatch;
    }

    // Fall back to matching language code only
    final langMatch = supportedLocales.cast<Locale?>().firstWhere(
      (l) => l?.languageCode == langCode,
      orElse: () => null,
    );
    if (langMatch != null) return langMatch;

    // Otherwise construct custom Locale
    return Locale(langCode, countryCode);
  }
}
