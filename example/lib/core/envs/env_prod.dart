import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';
import 'app_env.dart';

part 'env_prod.g.dart';

@Environment('prod')
@LazySingleton(as: AppEnv)
@Envied(name: 'EnvProd', obfuscate: true, requireEnvFile: false)
final class ProdEnv implements AppEnv {
  @override
  AppFlavor get flavor => AppFlavor.prod;

  @override
  @EnviedField(
    varName: 'APP_NAME',
    defaultValue: 'Enterprise Production App',
    obfuscate: true,
  )
  final String appName = _EnvProd.appName;

  @override
  @EnviedField(
    varName: 'API_BASE_URL',
    defaultValue: 'https://api.enterprise.production.com',
    obfuscate: true,
  )
  final String apiBaseUrl = _EnvProd.apiBaseUrl;

  @override
  @EnviedField(varName: 'ENABLE_LOGGING', defaultValue: false)
  final bool enableLogging = _EnvProd.enableLogging;

  @override
  @EnviedField(varName: 'API_TIMEOUT_SECONDS', defaultValue: 30)
  final int apiTimeoutSeconds = _EnvProd.apiTimeoutSeconds;

  @override
  bool get isDev => false;

  @override
  bool get isProd => true;
}
