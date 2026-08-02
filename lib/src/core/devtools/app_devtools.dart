import 'package:flutter/foundation.dart';

import '../logger/app_logger.dart';

/// Lightweight runtime dev tools: environment-conditional logging, debug
/// flags and performance timing helpers. Safe to use in release builds — the
/// guarded methods become no-ops when [enabled] is `false`.
class AppDevTools {
  AppDevTools({required this.enabled, required AppLogger logger})
    : _logger = logger;

  /// Whether diagnostics tooling is active (typically `kDebugMode`).
  final bool enabled;

  final AppLogger _logger;
  final Map<String, DateTime> _benchmarks = {};

  /// Records the start time of a benchmark identified by [name].
  void startBenchmark(String name) => _benchmarks[name] = DateTime.now();

  /// Logs the elapsed time since [startBenchmark] with the same [name].
  /// Returns the elapsed milliseconds.
  int? endBenchmark(String name) {
    if (!enabled) return null;
    final start = _benchmarks.remove(name);
    if (start == null) return null;
    final elapsed = DateTime.now().difference(start).inMilliseconds;
    _logger.debug('⏱ [$name] took $elapsed ms');
    return elapsed;
  }

  /// Logs a message only when [enabled] (debug-friendly).
  void log(String message) {
    if (enabled) _logger.debug('[DevTools] $message');
  }

  /// A factory tuned for debug builds. Always disabled in release.
  factory AppDevTools.debug({AppLogger? logger}) => AppDevTools(
    enabled: kDebugMode,
    logger: logger ?? AppLogger(environment: AppEnvironment.dev),
  );
}
