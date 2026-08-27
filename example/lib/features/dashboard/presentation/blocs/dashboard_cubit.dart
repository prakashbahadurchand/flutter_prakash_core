import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/dashboard_state.dart';

@injectable
class DashboardCubit extends BaseCubit<DashboardState> {
  final DashboardRepository _repository;

  DashboardCubit(this._repository) : super(const DashboardState());

  void selectTab(int index) {
    if (state.tabIndex != index) {
      safeEmit(state.copyWith(tabIndex: index));
    }
  }

  void toggleNotifications(bool value) {
    safeEmit(state.copyWith(notificationsEnabled: value));
    emitEffect(
      ShowToastEffect(
        value ? 'Push Notifications enabled' : 'Push Notifications disabled',
      ),
    );
  }

  void toggleCrashlytics(bool value) {
    safeEmit(state.copyWith(crashlyticsEnabled: value));
    emitEffect(
      ShowToastEffect(
        value
            ? 'Crashlytics collection active'
            : 'Crashlytics collection paused',
      ),
    );
  }

  void toggleAnalytics(bool value) {
    safeEmit(state.copyWith(analyticsEnabled: value));
    emitEffect(
      ShowToastEffect(
        value ? 'Firebase Analytics enabled' : 'Firebase Analytics disabled',
      ),
    );
  }

  void toggleBiometrics(bool value) {
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
