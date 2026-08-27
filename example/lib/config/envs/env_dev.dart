import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';
import 'app_env.dart';

part 'env_dev.g.dart';

@Environment('dev')
@LazySingleton(as: AppEnv)
@Envied(name: 'EnvDev', obfuscate: true, requireEnvFile: false)
final class DevEnv implements AppEnv {
  @override
  AppFlavor get flavor => AppFlavor.dev;

  @override
  @EnviedField(
    varName: 'APP_NAME',
    defaultValue: 'Flutter Prakash (Dev)',
    obfuscate: true,
  )
  final String appName = _EnvDev.appName;

  @override
  @EnviedField(
    varName: 'BASE_URL',
    defaultValue: 'http://127.0.0.1:8080',
    obfuscate: true,
  )
  final String apiBaseUrl = _EnvDev.apiBaseUrl;

  @override
  @EnviedField(varName: 'ENABLE_LOGGING', defaultValue: true)
  final bool enableLogging = _EnvDev.enableLogging;

  @override
  @EnviedField(varName: 'API_TIMEOUT_SECONDS', defaultValue: 15)
  final int apiTimeoutSeconds = _EnvDev.apiTimeoutSeconds;

  @override
  bool get isDev => true;

  @override
  bool get isProd => false;
}
