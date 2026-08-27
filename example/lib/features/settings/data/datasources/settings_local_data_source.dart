import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/features/settings/data/models/user_preferences_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SettingsLocalDataSource {
  final SharedPreferences _prefs;

  const SettingsLocalDataSource(this._prefs);

  UserPreferencesModel getUserPreferences() {
    return UserPreferencesModel(
      biometricsEnabled:
          _prefs.getBool(AppConstants.keyBiometricsEnabled) ?? false,
      notificationsEnabled:
          _prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true,
      analyticsEnabled:
          _prefs.getBool(AppConstants.keyAnalyticsEnabled) ?? true,
      crashlyticsEnabled:
          _prefs.getBool(AppConstants.keyCrashlyticsEnabled) ?? true,
    );
  }

  Future<bool> setBiometricsEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyBiometricsEnabled, value);

  Future<bool> setNotificationsEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyNotificationsEnabled, value);

  Future<bool> setAnalyticsEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyAnalyticsEnabled, value);

  Future<bool> setCrashlyticsEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyCrashlyticsEnabled, value);
}
