import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local notification service built on [flutter_local_notifications].
class LocalNotificationService {
  const LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the plugin (call once, e.g. from `main`).
  static Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings: settings);
  }

  /// Shows an immediate notification.
  static Future<void> show(
    int id,
    String title,
    String body, {
    String? payload,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          channelDescription: 'General application notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }

  static Future<void> cancel(int id) => _plugin.cancel(id: id);
}
