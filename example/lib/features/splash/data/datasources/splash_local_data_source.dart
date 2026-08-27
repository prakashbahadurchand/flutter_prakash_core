import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/features/splash/data/models/splash_init_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SplashLocalDataSource {
  final SharedPreferences _prefs;

  const SplashLocalDataSource(this._prefs);

  Future<SplashInitModel> checkAppInitialization() async {
    // Artificial slight delay to simulate bootstrap check
    await Future.delayed(const Duration(milliseconds: 600));

    final isOnboardingCompleted =
        _prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
    final token = _prefs.getString(AppConstants.keyUserToken);

    return SplashInitModel(
      isFirstLaunch: !isOnboardingCompleted,
      isOnboardingCompleted: isOnboardingCompleted,
      isAuthenticated: token != null && token.isNotEmpty,
      appVersion: AppConstants.appVersion,
    );
  }
}
