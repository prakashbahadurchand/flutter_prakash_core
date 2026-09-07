import 'dart:async';
import 'dart:ui' show ErrorCallback;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../../loggers/flutter_logger.dart';

/// Firebase Crashlytics manager for automated Flutter exception capturing,
/// custom key-value logging, non-fatal errors, and crash collection controls.
///
/// This manager preserves the previous [FlutterError.onError] and
/// [PlatformDispatcher.onError] handlers, chaining to them after reporting to
/// Crashlytics, so default framework error handling is not lost.
class FirebaseCrashlyticsManager {
  FirebaseCrashlyticsManager._();

  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  static FlutterExceptionHandler? _prevFlutterErrorHandler;
  static ErrorCallback? _prevPlatformErrorHandler;

  /// Initializes Crashlytics exception handlers for Flutter errors and platform errors.
  static Future<void> initialize({bool enableInDev = false}) async {
    final shouldEnable = kReleaseMode || enableInDev;
    await _crashlytics.setCrashlyticsCollectionEnabled(shouldEnable);

    if (shouldEnable) {
      // Preserve the previous handler so framework default logging is retained.
      _prevFlutterErrorHandler = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        unawaited(_crashlytics.recordFlutterFatalError(details));
        _prevFlutterErrorHandler?.call(details);
      };

      _prevPlatformErrorHandler = PlatformDispatcher.instance.onError;
      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(_crashlytics.recordError(error, stack, fatal: true));
        return _prevPlatformErrorHandler?.call(error, stack) ?? true;
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

  /// Restores the previous error handlers that were in place before
  /// [initialize] was called. Safe to call when not initialized.
  static void dispose() {
    if (_prevFlutterErrorHandler != null) {
      FlutterError.onError = _prevFlutterErrorHandler;
      _prevFlutterErrorHandler = null;
    }
    if (_prevPlatformErrorHandler != null) {
      PlatformDispatcher.instance.onError = _prevPlatformErrorHandler;
      _prevPlatformErrorHandler = null;
    }
  }

  /// Sets user identifier attached to crash logs.
  static Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }

  /// Logs a custom message string to Crashlytics breadcrumbs log.
  static void log(String message) {
    unawaited(_crashlytics.log(message));
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
