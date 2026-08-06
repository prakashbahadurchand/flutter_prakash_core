import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';

import 'analytics/firebase_analytics_manager.dart';
import 'cloud_messaging/firebase_cloud_messaging_manager.dart';
import 'crashlytics/firebase_crashlytics_manager.dart';
import 'inapp_messaging/firebase_inapp_messaging_manager.dart';
import 'performance_monitoring/firebase_performance_manager.dart';
import 'remote_config/firebase_remote_config_manager.dart';

/// Configurable feature toggles for [FirebaseEngine].
class FirebaseEngineConfig {
  final bool enableAnalytics;
  final bool enableCrashlytics;
  final bool enableMessaging;
  final bool enableRemoteConfig;
  final bool enableInAppMessaging;
  final bool enablePerformance;

  const FirebaseEngineConfig({
    this.enableAnalytics = true,
    this.enableCrashlytics = true,
    this.enableMessaging = true,
    this.enableRemoteConfig = true,
    this.enableInAppMessaging = false,
    this.enablePerformance = false,
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

    if (config.enableRemoteConfig) {
      await FirebaseRemoteConfigManager.initialize();
    }

    if (config.enableInAppMessaging) {
      await FirebaseInAppMessagingManager.triggerEvent('app_launch');
    }

    if (config.enablePerformance) {
      await FirebasePerformanceManager.setPerformanceCollectionEnabled(true);
    }

    return app;
  }
}
