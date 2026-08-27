import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:flutter_prakash_core_example/features/settings/data/repositories/settings_repository.dart';

@injectable
class DashboardCubit extends BaseCubit<DashboardState> {
  final DashboardRepository _repository;
  final SettingsRepository _settingsRepository;

  DashboardCubit(this._repository, this._settingsRepository)
    : super(const DashboardState());

  @postConstruct
  void init() => _loadPreferences();

  void selectTab(int index) {
    if (state.tabIndex != index) {
      if (index == DashboardTab.settings.tabNumber) {
        _loadPreferences();
      }
      safeEmit(state.copyWith(tabIndex: index));
    }
  }

  void _loadPreferences() {
    final preferences = _settingsRepository.getPreferences();
    safeEmit(
      state.copyWith(
        notificationsEnabled: preferences.notificationsEnabled,
        crashlyticsEnabled: preferences.crashlyticsEnabled,
        analyticsEnabled: preferences.analyticsEnabled,
        biometricsEnabled: preferences.biometricsEnabled,
      ),
    );
  }

  Future<void> toggleNotifications(bool value) async {
    await _settingsRepository.setNotifications(value);
    safeEmit(state.copyWith(notificationsEnabled: value));
    emitEffect(
      ShowToastEffect(
        value ? 'Push Notifications enabled' : 'Push Notifications disabled',
      ),
    );
  }

  Future<void> toggleCrashlytics(bool value) async {
    await _settingsRepository.setCrashlytics(value);
    safeEmit(state.copyWith(crashlyticsEnabled: value));
    emitEffect(
      ShowToastEffect(
        value
            ? 'Crashlytics collection active'
            : 'Crashlytics collection paused',
      ),
    );
  }

  Future<void> toggleAnalytics(bool value) async {
    await _settingsRepository.setAnalytics(value);
    safeEmit(state.copyWith(analyticsEnabled: value));
    emitEffect(
      ShowToastEffect(
        value ? 'Firebase Analytics enabled' : 'Firebase Analytics disabled',
      ),
    );
  }

  Future<void> toggleBiometrics(bool value) async {
    await _settingsRepository.setBiometrics(value);
    safeEmit(state.copyWith(biometricsEnabled: value));
    emitEffect(
      ShowToastEffect(
        value
            ? 'Biometric Authentication active'
            : 'Biometric Authentication disabled',
      ),
    );
  }

  Future<void> clearCache() async {
    await _repository.clearCache();
    emitEffect(const ShowToastEffect('Cache cleared successfully!'));
  }
}
