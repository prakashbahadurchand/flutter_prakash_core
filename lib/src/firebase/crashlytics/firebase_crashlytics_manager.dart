import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_prakash_core/src/loggers/flutter_logger.dart';

/// Firebase Crashlytics manager for automated Flutter exception capturing,
/// custom key-value logging, non-fatal errors, and crash collection controls.
class FirebaseCrashlyticsManager {
  FirebaseCrashlyticsManager._();

  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initializes Crashlytics exception handlers for Flutter errors and platform errors.
  static Future<void> initialize({bool enableInDev = false}) async {
    final shouldEnable = kReleaseMode || enableInDev;
    await _crashlytics.setCrashlyticsCollectionEnabled(shouldEnable);

    if (shouldEnable) {
      // Pass all uncaught Flutter errors to Crashlytics
      FlutterError.onError = _crashlytics.recordFlutterFatalError;

      // Pass uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      FlutterLogger.info(
        'Firebase Crashlytics collection enabled',
        tag: 'CRASHLYTICS',
      );
    } else {
      FlutterLogger.info(
        'Firebase Crashlytics collection disabled (Non-release mode)',
        tag: 'CRASHLYTICS',
      );
    }
  }

  /// Sets user identifier attached to crash logs.
  static Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }

  /// Logs a custom message string to Crashlytics breadcrumbs log.
  static void log(String message) {
    _crashlytics.log(message);
  }

  /// Sets custom key-value pair attributes for crash reports.
  static Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Manually records a non-fatal exception/error to Crashlytics.
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }
}
