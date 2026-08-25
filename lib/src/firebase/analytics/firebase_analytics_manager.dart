import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_prakash/src/loggers/flutter_logger.dart';

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
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Log login event.
  static Future<void> logLogin({String loginMethod = 'email'}) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  /// Log sign up event.
  static Future<void> logSignUp({required String signUpMethod}) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  /// Reset analytics data.
  static Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
  }
}
