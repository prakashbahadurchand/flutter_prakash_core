import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_locale.dart';

/// Cache key definition for local storage isolation
const String _localePreferenceKey = 'application_language_code';

/// An enterprise persistent [LocaleCubit] backed directly by [SharedPreferences].
@lazySingleton
class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences _preferences;

  LocaleCubit(this._preferences)
    : super(
        AppLocale.fromLanguageCode(
          // Pull the string directly from storage; falls back to null if empty
          _preferences.getString(_localePreferenceKey),
        ).locale,
      );

  /// Changes the current application locale and persists it directly to [SharedPreferences].
  Future<void> setLocale(Locale newLocale) async {
    if (state == newLocale) return;
    emit(newLocale);

    // Save the raw string key value directly into shared preferences
    await _preferences.setString(_localePreferenceKey, newLocale.languageCode);
  }

  /// Sets locale using [AppLocale] enum.
  Future<void> setAppLocale(AppLocale appLocale) async {
    await setLocale(appLocale.locale);
  }

  /// Checks if current language direction is Right-to-Left (e.g. Arabic, Hebrew).
  bool get isRtl => state.languageCode == 'ar' || state.languageCode == 'he';
}
