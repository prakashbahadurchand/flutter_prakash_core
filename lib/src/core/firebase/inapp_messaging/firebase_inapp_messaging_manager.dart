import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';

/// Firebase In-App Messaging manager for controlling contextual in-app messages and campaign triggers.
class FirebaseInAppMessagingManager {
  FirebaseInAppMessagingManager._();

  static final FirebaseInAppMessaging _inAppMessaging =
      FirebaseInAppMessaging.instance;

  /// Enable or disable in-app messaging message suppression.
  static Future<void> setMessagesSuppressed(bool suppressed) async {
    await _inAppMessaging.setMessagesSuppressed(suppressed);
    FlutterLogger.info(
      'In-App Messaging suppressed: $suppressed',
      tag: 'IN_APP_MESSAGING',
    );
  }

  /// Programmatically trigger an in-app message event.
  static Future<void> triggerEvent(String eventName) async {
    await _inAppMessaging.triggerEvent(eventName);
    FlutterLogger.info(
      'Triggered In-App Messaging event: $eventName',
      tag: 'IN_APP_MESSAGING',
    );
  }

  /// Enables automatic data collection for In-App Messaging.
  static Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {
    await _inAppMessaging.setAutomaticDataCollectionEnabled(enabled);
  }
}
