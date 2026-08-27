import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/settings/data/models/user_preferences_model.dart';
import 'package:flutter_prakash_core_example/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/settings_state.dart';

@injectable
class SettingsCubit extends BaseCubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository)
      : super(
          SettingsState(
            preferences: const UserPreferencesModel(
              biometricsEnabled: false,
              notificationsEnabled: true,
              analyticsEnabled: true,
              crashlyticsEnabled: true,
            ),
          ),
        );

  @postConstruct
  void init() {
    final prefs = _repository.getPreferences();
    safeEmit(state.copyWith(preferences: prefs));
  }

  Future<void> toggleBiometrics(bool value) async {
    await _repository.setBiometrics(value);
    final updated = UserPreferencesModel(
      biometricsEnabled: value,
      notificationsEnabled: state.preferences.notificationsEnabled,
      analyticsEnabled: state.preferences.analyticsEnabled,
      crashlyticsEnabled: state.preferences.crashlyticsEnabled,
    );
    safeEmit(state.copyWith(preferences: updated));
    emitEffect(
      ShowToastEffect(
        value ? 'Biometrics activated' : 'Biometrics deactivated',
      ),
    );
  }

  Future<void> toggleNotifications(bool value) async {
    await _repository.setNotifications(value);
    final updated = UserPreferencesModel(
      biometricsEnabled: state.preferences.biometricsEnabled,
      notificationsEnabled: value,
      analyticsEnabled: state.preferences.analyticsEnabled,
      crashlyticsEnabled: state.preferences.crashlyticsEnabled,
    );
    safeEmit(state.copyWith(preferences: updated));
  }

  Future<void> toggleAnalytics(bool value) async {
    await _repository.setAnalytics(value);
    final updated = UserPreferencesModel(
      biometricsEnabled: state.preferences.biometricsEnabled,
      notificationsEnabled: state.preferences.notificationsEnabled,
      analyticsEnabled: value,
      crashlyticsEnabled: state.preferences.crashlyticsEnabled,
    );
    safeEmit(state.copyWith(preferences: updated));
  }

  Future<void> toggleCrashlytics(bool value) async {
    await _repository.setCrashlytics(value);
    final updated = UserPreferencesModel(
      biometricsEnabled: state.preferences.biometricsEnabled,
      notificationsEnabled: state.preferences.notificationsEnabled,
      analyticsEnabled: state.preferences.analyticsEnabled,
      crashlyticsEnabled: value,
    );
    safeEmit(state.copyWith(preferences: updated));
  }
}
