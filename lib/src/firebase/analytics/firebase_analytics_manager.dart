import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../../loggers/flutter_logger.dart';

/// Firebase Analytics Manager supporting custom events, screen tracking, user ID and properties.
class FirebaseAnalyticsManager {
  FirebaseAnalyticsManager._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Returns the observer for tracking Navigator page views.
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Enable or disable analytics data collection.
  static Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
    FlutterLogger.info(
      'Firebase Analytics collection enabled: $enabled',
      tag: 'ANALYTICS',
    );
  }

  /// Sets the user ID for analytics tracking.
  static Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
    FlutterLogger.info('Set Analytics UserId: $userId', tag: 'ANALYTICS');
  }

  /// Sets a user property key and value.
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
    FlutterLogger.info('Set User Property: $name = $value', tag: 'ANALYTICS');
  }

  /// Log a custom analytics event.
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!kReleaseMode) {
      FlutterLogger.debug(
        'Logging Analytics Event [$name] with parameters: $parameters',
        tag: 'ANALYTICS',
      );
    }
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  /// Log screen view event manually.
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      FlutterLogger.error('Failed to log screen view: $e', tag: 'ANALYTICS');
    }
  }

  /// Log login event.
  static Future<void> logLogin({String loginMethod = 'email'}) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
    } catch (e) {
      FlutterLogger.error('Failed to log login event: $e', tag: 'ANALYTICS');
    }
  }

  /// Log sign up event.
  static Future<void> logSignUp({required String signUpMethod}) async {
    try {
      await _analytics.logSignUp(signUpMethod: signUpMethod);
    } catch (e) {
      FlutterLogger.error('Failed to log signup event: $e', tag: 'ANALYTICS');
    }
  }

  /// Reset analytics data.
  static Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
    } catch (e) {
      FlutterLogger.error(
        'Failed to reset analytics data: $e',
        tag: 'ANALYTICS',
      );
    }
  }
}
