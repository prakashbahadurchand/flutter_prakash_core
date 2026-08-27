abstract final class AppConstants {
  // App Info
  static const String appName = 'Flutter Prakash';
  static const String appTagline = 'Enterprise Multi-App Core Platform';
  static const String appVersion = '1.0.2';
  static const int appBuildNumber = 1;

  // Storage Keys
  static const String keyOnboardingCompleted = 'is_onboarding_completed';
  static const String keyUserToken = 'user_auth_token';
  static const String keyBiometricsEnabled = 'pref_biometrics_enabled';
  static const String keyNotificationsEnabled = 'pref_notifications_enabled';
  static const String keyAnalyticsEnabled = 'pref_analytics_enabled';
  static const String keyCrashlyticsEnabled = 'pref_crashlytics_enabled';
  static const String keyThemeMode = 'app_theme_mode';
  static const String keyLocale = 'app_locale';

  // Network Defaults
  static const int connectTimeoutSeconds = 15;
  static const int receiveTimeoutSeconds = 15;

  // Asset Paths
  static const String logoAsset = 'assets/images/app-icon/icon-dev.png';
}
