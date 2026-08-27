enum AppFlavor { dev, prod }

abstract interface class AppEnv {
  AppFlavor get flavor;
  String get appName;
  String get apiBaseUrl;
  bool get enableLogging;
  int get apiTimeoutSeconds;

  bool get isDev;
  bool get isProd;
}
