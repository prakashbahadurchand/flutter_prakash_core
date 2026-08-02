import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';

/// Firebase Performance Monitoring manager for measuring network requests, HTTP traces,
/// custom code traces, and performance data collection toggles.
class FirebasePerformanceManager {
  FirebasePerformanceManager._();

  static final FirebasePerformance _performance =
      FirebasePerformance.instance;

  /// Enables or disables performance collection.
  static Future<void> setPerformanceCollectionEnabled(bool enabled) async {
    await _performance.setPerformanceCollectionEnabled(enabled);
    FlutterLogger.info(
      'Firebase Performance collection enabled: $enabled',
      tag: 'PERFORMANCE',
    );
  }

  /// Starts a custom performance trace.
  static Future<Trace> startTrace(String name) async {
    final trace = _performance.newTrace(name);
    await trace.start();
    FlutterLogger.info('Started custom Trace: $name', tag: 'PERFORMANCE');
    return trace;
  }

  /// Measures execution duration of an async action via a custom trace.
  static Future<T> traceAction<T>(
    String traceName,
    Future<T> Function() action,
  ) async {
    final trace = await startTrace(traceName);
    try {
      final result = await action();
      return result;
    } finally {
      await trace.stop();
      FlutterLogger.info('Stopped custom Trace: $traceName', tag: 'PERFORMANCE');
    }
  }

  /// Creates an HTTP metric for tracking network requests manually.
  static HttpMetric newHttpMetric(String url, HttpMethod method) {
    return _performance.newHttpMetric(url, method);
  }
}
