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

/// Master Firebase Suite Engine for Flutter Prakash applications.
class FirebaseEngine {
  FirebaseEngine._();

  static bool _isInitialized = false;

  /// Returns true if Firebase has been initialized.
  static bool get isInitialized => _isInitialized;

  /// Initializes Firebase Core and optional configured Firebase services.
  static Future<FirebaseApp> initialize({
    FirebaseOptions? options,
    FirebaseEngineConfig config = const FirebaseEngineConfig(),
  }) async {
    final app = await Firebase.initializeApp(options: options);
    _isInitialized = true;
    FlutterLogger.i('Firebase Core initialized: ${app.name}', tag: 'FIREBASE');

    if (config.enableAnalytics) {
      await FirebaseAnalyticsManager.logEvent(name: 'app_initialized');
    }

    if (config.enableCrashlytics) {
      await FirebaseCrashlyticsManager.initialize();
    }

    if (config.enableMessaging) {
      await FirebaseCloudMessagingManager.initialize();
    }

    return app;
  }
}
