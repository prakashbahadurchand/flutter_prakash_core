import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache key definition for local theme storage isolation
const String _themePreferenceKey = 'application_theme_mode_index';

/// An enterprise persistent [ThemeCubit] backed directly by [SharedPreferences].
@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _preferences;

  ThemeCubit(this._preferences)
    : super(
        // Read integer index, mapping safely back to the ThemeMode Enum collections
        _getStoredThemeMode(_preferences),
      );

  /// Toggles between Light and Dark mode, persisting the new value directly.
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Sets specific [ThemeMode] (system, light, dark) and saves to local storage.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    emit(mode);

    // Save the raw enum index directly into shared preferences
    await _preferences.setInt(_themePreferenceKey, mode.index);
  }

  /// Whether the current active mode is dark.
  bool get isDarkMode => state == ThemeMode.dark;

  bool get isLightMode => state == ThemeMode.light;

  bool get isSystemMode => state == ThemeMode.system;

  /// Private helper utility to decode the stored index back into a clean fallback
  static ThemeMode _getStoredThemeMode(SharedPreferences prefs) {
    final int? storedIndex = prefs.getInt(_themePreferenceKey);
    if (storedIndex == null) return ThemeMode.system; // Clean default fallback

    // Safety guard to avoid bounds overflow crashes if database state is altered
    if (storedIndex >= 0 && storedIndex < ThemeMode.values.length) {
      return ThemeMode.values[storedIndex];
    }
    return ThemeMode.system;
  }
}
