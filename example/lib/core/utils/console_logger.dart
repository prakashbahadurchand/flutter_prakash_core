import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Clean, colorful, compact ANSI console logger with rich formatting & emojis.
class ConsoleLogger {
  ConsoleLogger._();

  // ANSI Escape Codes for Terminal & Debug Console Coloring
  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';
  static const String _dim = '\x1B[2m';

  // Colors
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';

  /// ℹ️ Informational log (Cyan)
  static void info(String message, {String tag = 'APP'}) {
    _log(emoji: 'ℹ️', color: _cyan, tag: tag, message: message);
  }

  /// ✅ Success log (Green)
  static void success(String message, {String tag = 'SUCCESS'}) {
    _log(emoji: '✅', color: _green, tag: tag, message: message);
  }

  /// ⚠️ Warning log (Yellow)
  static void warning(String message, {String tag = 'WARN', Object? error}) {
    final errStr = error != null ? ' | Details: $error' : '';
    _log(emoji: '⚠️', color: _yellow, tag: tag, message: '$message$errStr');
  }

  /// 🚨 Error log (Red)
  static void error(
    String message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    final errStr = error != null ? '\n   $_dim└─ Error: $error$_reset' : '';
    _log(
      emoji: '🚨',
      color: _red,
      tag: tag,
      message: '$message$errStr',
      stackTrace: stackTrace,
    );
  }

  /// 📢 Ad Lifecycle event log (Blue / Magenta)
  static void adLifecycle({
    required String format,
    required String event,
    String? adUnitId,
  }) {
    final unitStr = adUnitId != null ? ' $_dim($adUnitId)$_reset' : '';
    _log(
      emoji: '📢',
      color: _blue,
      tag: 'AD-LIFECYCLE',
      message: '$_bold[$format]$_reset ➔ $_cyan$event$_reset$unitStr',
    );
  }

  /// 💰 Impression-level Revenue (ROAS) log (Green & Magenta)
  static void adRevenue({
    required String format,
    required double revenue,
    required double micros,
    required String currency,
    required String precision,
    String? adUnitId,
  }) {
    final formattedRevenue = revenue.toStringAsFixed(6);
    final formattedMicros = micros.toStringAsFixed(2);
    final unitStr = adUnitId != null ? ' $_dim[$adUnitId]$_reset' : '';

    _log(
      emoji: '💰',
      color: _green,
      tag: 'ROAS',
      message:
          '$_bold[$format]$_reset $_green\$$formattedRevenue $currency$_reset '
          '$_magenta($formattedMicros µs)$_reset '
          '$_dim[Precision: $precision]$_reset$unitStr',
    );
  }

  /// 🚀 App Startup Banner Box
  static void startupBanner({
    required String appName,
    required String version,
    required String environment,
  }) {
    if (!kDebugMode) return;

    final line = '═' * 52;
    debugPrint(
      '$_cyan$_bold╔$line╗\n'
      '║  🚀 $appName v$version ($environment)\n'
      '║  🛡️ Google Mobile Ads Clean Architecture\n'
      '╚$line╝$_reset',
    );
  }

  static void _log({
    required String emoji,
    required String color,
    required String tag,
    required String message,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final timestamp = _formatTime(DateTime.now());
    final formatted =
        '$_dim$timestamp$_reset $color$emoji $_bold[$tag]$_reset $color$message$_reset';

    debugPrint(formatted);

    // Also pipe to Dart Developer Log for observatory / DevTools timeline
    developer.log('$emoji [$tag] $message', name: tag, stackTrace: stackTrace);
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final ms = dt.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }
}
