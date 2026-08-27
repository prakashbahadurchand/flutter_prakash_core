class SplashInitModel {
  final bool isFirstLaunch;
  final bool isOnboardingCompleted;
  final bool isAuthenticated;
  final String appVersion;

  const SplashInitModel({
    required this.isFirstLaunch,
    required this.isOnboardingCompleted,
    required this.isAuthenticated,
    required this.appVersion,
  });
}
