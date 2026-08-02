import 'package:logger/logger.dart';

enum AppEnvironment { dev, staging, prod }

class AppLogger {
  final AppEnvironment environment;
  late final Logger _logger;

  AppLogger({this.environment = AppEnvironment.dev}) {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: environment == AppEnvironment.dev ? 2 : 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
      ),
    );
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (environment == AppEnvironment.dev) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  void info(String message) {
    _logger.i(message);
  }

  void warning(String message, [dynamic error]) {
    _logger.w(message, error: error);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
