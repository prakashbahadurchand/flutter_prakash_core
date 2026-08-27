import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/settings/data/models/user_preferences_model.dart';

@lazySingleton
class SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  const SettingsRepository(this._localDataSource);

  UserPreferencesModel getPreferences() =>
      _localDataSource.getUserPreferences();

  FutureResult<bool> setBiometrics(bool value) {
    return Result.fromAsync(
      call: () => _localDataSource.setBiometricsEnabled(value),
    );
  }

  FutureResult<bool> setNotifications(bool value) {
    return Result.fromAsync(
      call: () => _localDataSource.setNotificationsEnabled(value),
    );
  }

  FutureResult<bool> setAnalytics(bool value) {
    return Result.fromAsync(
      call: () => _localDataSource.setAnalyticsEnabled(value),
    );
  }

  FutureResult<bool> setCrashlytics(bool value) {
    return Result.fromAsync(
      call: () => _localDataSource.setCrashlyticsEnabled(value),
    );
  }
}
