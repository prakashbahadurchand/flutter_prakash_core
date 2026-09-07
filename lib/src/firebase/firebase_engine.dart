import 'package:firebase_core/firebase_core.dart';
import '../loggers/flutter_logger.dart';

import 'analytics/firebase_analytics_manager.dart';
import 'cloud_messaging/firebase_cloud_messaging_manager.dart';
import 'crashlytics/firebase_crashlytics_manager.dart';

/// Configurable feature toggles for [FirebaseEngine].
class FirebaseEngineConfig {
  final bool enableAnalytics;
  final bool enableCrashlytics;
  final bool enableMessaging;

  const FirebaseEngineConfig({
    this.enableAnalytics = true,
    this.enableCrashlytics = true,
    this.enableMessaging = true,
  });
}

/// Result of individual Firebase service initialization.
class FirebaseServiceInitResult {
  final bool success;
  final Object? error;

  const FirebaseServiceInitResult._(this.success, this.error);

  bool get isSuccess => success;
  Object? get errorValue => error;

  @override
  String toString() =>
      'FirebaseServiceInitResult(success: $success, error: $error)';
}

/// Master Firebase Suite Engine for Flutter Prakash applications.
///
/// Initializes Firebase Core and optionally configured Firebase services
/// (Analytics, Crashlytics, Messaging). Each optional service is wrapped in
/// its own try/catch so that a single service failure does not abort the
/// entire initialization sequence.
class FirebaseEngine {
  FirebaseEngine._();

  static bool _isInitialized = false;

  /// Returns true if Firebase has been initialized.
  static bool get isInitialized => _isInitialized;

  /// Initializes Firebase Core and optional configured Firebase services.
  ///
  /// Returns the initialized [FirebaseApp]. Individual optional services
  /// (analytics, crashlytics, messaging) are initialized defensively:
  /// if one fails, its error is logged and initialization continues so the
  /// remaining services still get a chance to start.
  static Future<FirebaseApp> initialize({
    FirebaseOptions? options,
    FirebaseEngineConfig config = const FirebaseEngineConfig(),
  }) async {
    final app = await Firebase.initializeApp(options: options);
    _isInitialized = true;
    FlutterLogger.i('Firebase Core initialized: ${app.name}', tag: 'FIREBASE');

    if (config.enableAnalytics) {
      await _initWithCatch(
        name: 'Analytics',
        call: () async {
          await FirebaseAnalyticsManager.setAnalyticsCollectionEnabled(true);
          await FirebaseAnalyticsManager.logEvent(name: 'app_initialized');
        },
      );
    }

    if (config.enableCrashlytics) {
      await _initWithCatch(
        name: 'Crashlytics',
        call: () => FirebaseCrashlyticsManager.initialize(),
      );
    }

    if (config.enableMessaging) {
      await _initWithCatch(
        name: 'Messaging',
        call: () => FirebaseCloudMessagingManager.initialize(),
      );
    }

    return app;
  }

  static Future<void> _initWithCatch({
    required String name,
    required Future<void> Function() call,
  }) async {
    try {
      await call();
    } catch (e, stackTrace) {
      FlutterLogger.error(
        'Failed to initialize Firebase $name: $e',
        tag: 'FIREBASE',
      );
      FlutterLogger.debug('$stackTrace', tag: 'FIREBASE');
    }
  }
}
