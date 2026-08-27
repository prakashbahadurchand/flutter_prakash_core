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
    safeEmit(
      state.copyWith(
        preferences: state.preferences.copyWith(biometricsEnabled: value),
      ),
    );
    emitEffect(
      ShowToastEffect(
        value ? 'Biometrics activated' : 'Biometrics deactivated',
      ),
    );
  }

  Future<void> toggleNotifications(bool value) async {
    await _repository.setNotifications(value);
    safeEmit(
      state.copyWith(
        preferences: state.preferences.copyWith(notificationsEnabled: value),
      ),
    );
  }

  Future<void> toggleAnalytics(bool value) async {
    await _repository.setAnalytics(value);
    safeEmit(
      state.copyWith(
        preferences: state.preferences.copyWith(analyticsEnabled: value),
      ),
    );
  }

  Future<void> toggleCrashlytics(bool value) async {
    await _repository.setCrashlytics(value);
    safeEmit(
      state.copyWith(
        preferences: state.preferences.copyWith(crashlyticsEnabled: value),
      ),
    );
  }
}
