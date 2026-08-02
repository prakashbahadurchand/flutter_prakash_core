import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Severity levels for [FlutterLogger].
enum LogLevel {
  debug('DEBUG', 94, '🐛'), // Blue
  info('INFO', 92, 'ℹ️'), // Green
  warning('WARN', 93, '⚠️'), // Yellow
  error('ERROR', 91, '💥'), // Red
  severe('SEVERE', 95, '🚨'); // Magenta

  const LogLevel(this.name, this.colorCode, this.emoji);

  final String name;
  final int colorCode;
  final String emoji;
}

/// A comprehensive logger for Flutter applications with ANSI color highlights,
/// JSON/object pretty-printing, configurable tags, error handling, and stack traces.
///
/// Example usage with top-level helper functions:
/// ```dart
/// logInfo('User logged in successfully');
/// logDebug({'userId': 123, 'token': 'abc-123'}, tag: 'AUTH');
/// logWarn('Network latency high', tag: 'NETWORK');
///
/// try {
///   // Perform risky task
/// } catch (e, stack) {
///   logError('Failed to fetch user profile', error: e, stackTrace: stack);
/// }
///
/// log('Critical system alert!', level: LogLevel.severe, tag: 'SYSTEM');
/// ```
class FlutterLogger {
  FlutterLogger._();

  static const _dividerTilde =
      '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
  static const _dividerDotted =
      '......................................................................';

  /// Master flag to enable or disable logging. Defaults to [kDebugMode].
  static bool isEnabled = kDebugMode;

  /// Maximum length for pretty-printed JSON strings before truncation.
  static int maxBodyLength = 10000;

  /// Print a debug log message.
  static void debug(
    dynamic message, {
    String tag = 'DEBUG',
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      level: LogLevel.debug,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Print an info log message.
  static void info(
    dynamic message, {
    String tag = 'INFO',
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      level: LogLevel.info,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Print a warning log message.
  static void warning(
    dynamic message, {
    String tag = 'WARN',
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      level: LogLevel.warning,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Print an error log message.
  static void error(
    dynamic message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      message,
      level: LogLevel.error,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Generic log method supporting custom log levels, formatted objects/JSON, errors, and stack traces.
  static void log(
    dynamic message, {
    LogLevel level = LogLevel.debug,
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!isEnabled || !kDebugMode) return;

    final headerText = '${level.emoji} [${level.name}] [$tag]';
    final coloredHeader = _colorize(headerText, level.colorCode);

    final buffer = StringBuffer()
      ..writeln('\n$_dividerTilde')
      ..writeln(coloredHeader)
      ..writeln(_dividerTilde);

    if (message != null) {
      buffer.writeln('Data:');
      buffer.writeln(_prettyJson(message));
      buffer.writeln(_dividerDotted);
    }

    if (error != null) {
      buffer.writeln('\x1B[91mError: $error\x1B[0m');
      buffer.writeln(_dividerDotted);
    }

    if (stackTrace != null) {
      buffer.writeln('StackTrace:\n$stackTrace');
      buffer.writeln(_dividerDotted);
    }

    dev.log(buffer.toString(), name: tag);
  }

  /// Pretty-prints dynamic objects or JSON strings with ANSI syntax highlighting.
  static String _prettyJson(dynamic jsonObject) {
    if (jsonObject == null) return '\x1B[33mnull\x1B[0m';
    try {
      dynamic objectToConvert = jsonObject;
      if (jsonObject is String) {
        if (jsonObject.length > maxBodyLength) {
          final truncated = jsonObject.substring(0, maxBodyLength);
          final remaining = jsonObject.length - maxBodyLength;
          return '$truncated\n... [TRUNCATED - $remaining more characters]';
        }
        try {
          objectToConvert = jsonDecode(jsonObject);
        } catch (_) {
          return jsonObject;
        }
      }

      const encoder = JsonEncoder.withIndent('  ');
      var jsonString = encoder.convert(objectToConvert);

      // 1. Colorize strings (Green) and literals (Yellow)
      jsonString = jsonString.replaceAllMapped(
        RegExp(
          r'("([^"\\]*(\\.[^"\\]*)*)")|(-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?|\btrue\b|\bfalse\b|\bnull\b)',
        ),
        (match) {
          if (match.group(1) != null) {
            return '\x1B[32m${match.group(1)}\x1B[0m'; // String
          } else {
            return '\x1B[33m${match.group(4)}\x1B[0m'; // Literal
          }
        },
      );

      // 2. Fix keys: any green string immediately followed by a colon becomes Cyan
      jsonString = jsonString.replaceAllMapped(
        RegExp(r'\x1B\[32m("([^"\\]*(\\.[^"\\]*)*)")\x1B\[0m(?=\s*:)'),
        (match) => '\x1B[36m${match.group(1)}\x1B[0m',
      );

      // 3. Unescape newlines for readability in logs
      jsonString = jsonString.replaceAll(r'\n', '\n');

      return jsonString;
    } catch (e) {
      return jsonObject.toString();
    }
  }

  static String _colorize(String text, int colorCode) {
    return '\x1B[${colorCode}m$text\x1B[0m';
  }
}

// =============================================================================
// Top-Level Convenience Logging Functions
// =============================================================================

/// Top-level helper function for debug logs.
void logDebug(
  dynamic message, {
  String tag = 'DEBUG',
  Object? error,
  StackTrace? stackTrace,
}) {
  FlutterLogger.debug(message, tag: tag, error: error, stackTrace: stackTrace);
}

/// Top-level helper function for info logs.
void logInfo(
  dynamic message, {
  String tag = 'INFO',
  Object? error,
  StackTrace? stackTrace,
}) {
  FlutterLogger.info(message, tag: tag, error: error, stackTrace: stackTrace);
}

/// Top-level helper function for warning logs.
void logWarn(
  dynamic message, {
  String tag = 'WARN',
  Object? error,
  StackTrace? stackTrace,
}) {
  FlutterLogger.warning(
    message,
    tag: tag,
    error: error,
    stackTrace: stackTrace,
  );
}

/// Top-level helper function for error logs.
void logError(
  dynamic message, {
  String tag = 'ERROR',
  Object? error,
  StackTrace? stackTrace,
}) {
  FlutterLogger.error(message, tag: tag, error: error, stackTrace: stackTrace);
}

/// Top-level generic helper function for logging with a custom [LogLevel].
void log(
  dynamic message, {
  LogLevel level = LogLevel.debug,
  String tag = 'APP',
  Object? error,
  StackTrace? stackTrace,
}) {
  FlutterLogger.log(
    message,
    level: level,
    tag: tag,
    error: error,
    stackTrace: stackTrace,
  );
}
