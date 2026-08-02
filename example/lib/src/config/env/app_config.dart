enum AppEnvironment { dev, prod }

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.environment,
    required this.baseUrl,
  });

  final String appName;
  final AppEnvironment environment;
  final String baseUrl;

  static late final AppConfig instance;

  static void init({
    required String appName,
    required AppEnvironment environment,
    required String baseUrl,
  }) {
    instance = AppConfig(
      appName: appName,
      environment: environment,
      baseUrl: baseUrl,
    );
  }
}
