import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_prakash_core/src/loggers/flutter_logger.dart';

/// Background message handler callback for FCM. Must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterLogger.info(
    'Handling background FCM message: ${message.messageId}',
    tag: 'MESSAGING',
  );
}

/// Firebase Cloud Messaging (FCM) Manager for handling permissions, FCM tokens, topics,
/// and foreground / background message streams.
class FirebaseCloudMessagingManager {
  FirebaseCloudMessagingManager._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initializes FCM setup, registers background handler, and requests permissions.
  static Future<NotificationSettings> initialize({
    void Function(RemoteMessage message)? onForegroundMessage,
    void Function(RemoteMessage message)? onMessageOpenedApp,
  }) async {
    final settings = await requestPermission();

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FlutterLogger.info(
        'Foreground FCM message received: ${message.notification?.title}',
        tag: 'MESSAGING',
      );
      onForegroundMessage?.call(message);
    });

    // Listen to messages opened when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      FlutterLogger.info(
        'App opened via FCM notification: ${message.notification?.title}',
        tag: 'MESSAGING',
      );
      onMessageOpenedApp?.call(message);
    });

    return settings;
  }

  /// Requests notification permissions on iOS / macOS / Web / Android 13+.
  static Future<NotificationSettings> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    FlutterLogger.info(
      'FCM Notification Permission status: ${settings.authorizationStatus}',
      tag: 'MESSAGING',
    );
    return settings;
  }

  /// Retrieves the current FCM registration token.
  static Future<String?> getToken({String? vapidKey}) async {
    try {
      final token = await _messaging.getToken(vapidKey: vapidKey);
      FlutterLogger.info('FCM Token: $token', tag: 'MESSAGING');
      return token;
    } catch (e) {
      FlutterLogger.error('Failed to retrieve FCM token: $e', tag: 'MESSAGING');
      return null;
    }
  }

  /// Listens to FCM token refresh events.
  static Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Subscribes to a pub/sub notification topic.
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    FlutterLogger.info('Subscribed to FCM topic: $topic', tag: 'MESSAGING');
  }

  /// Unsubscribes from a notification topic.
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    FlutterLogger.info('Unsubscribed from FCM topic: $topic', tag: 'MESSAGING');
  }

  /// Retrieves the initial message if the app was launched from a terminated state.
  static Future<RemoteMessage?> getInitialMessage() async {
    return _messaging.getInitialMessage();
  }
}
