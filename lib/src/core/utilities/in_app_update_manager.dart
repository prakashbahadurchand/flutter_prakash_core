import 'package:flutter/foundation.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';
import 'package:in_app_update/in_app_update.dart';

/// App update info summary for immediate handling by host apps.
class AppUpdateInfoResult {
  final bool updateAvailable;
  final bool immediateUpdateAllowed;
  final bool flexibleUpdateAllowed;
  final int? availableVersionCode;
  final String? packageName;

  const AppUpdateInfoResult({
    required this.updateAvailable,
    required this.immediateUpdateAllowed,
    required this.flexibleUpdateAllowed,
    this.availableVersionCode,
    this.packageName,
  });
}

/// In-App Update Manager for handling Play Store updates (Flexible & Immediate).
///
/// Provides a seamless interface for checking for updates, starting flexible/immediate updates,
/// and completing flexible updates on Android devices.
class InAppUpdateManager {
  InAppUpdateManager._();

  static const String _logTag = 'IN_APP_UPDATE';

  /// Returns `true` if In-App Update is supported on the current platform (Android only).
  static bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Checks Google Play Store for an available app update.
  ///
  /// Returns an [AppUpdateInfoResult] with update status, available version code,
  /// and allowed update modes (flexible / immediate).
  static Future<AppUpdateInfoResult?> checkForUpdate() async {
    if (!isSupported) {
      FlutterLogger.debug(
        'In-App Update is only supported on Android.',
        tag: _logTag,
      );
      return null;
    }

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      final isAvailable =
          updateInfo.updateAvailability == UpdateAvailability.updateAvailable;

      FlutterLogger.info(
        'In-App Update availability: ${updateInfo.updateAvailability} '
        '(Available version: ${updateInfo.availableVersionCode})',
        tag: _logTag,
      );

      return AppUpdateInfoResult(
        updateAvailable: isAvailable,
        immediateUpdateAllowed: updateInfo.immediateUpdateAllowed,
        flexibleUpdateAllowed: updateInfo.flexibleUpdateAllowed,
        availableVersionCode: updateInfo.availableVersionCode,
        packageName: updateInfo.packageName,
      );
    } catch (e, stack) {
      FlutterLogger.error(
        'Failed to check for in-app update: $e',
        tag: _logTag,
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Starts a Flexible in-app update flow.
  ///
  /// Flexible updates allow users to continue using the app while the update downloads in the background.
  /// Call [completeFlexibleUpdate] after the download finishes to install it.
  static Future<bool> startFlexibleUpdate() async {
    if (!isSupported) return false;

    try {
      FlutterLogger.info('Starting Flexible In-App Update...', tag: _logTag);
      final result = await InAppUpdate.startFlexibleUpdate();
      final success = result == AppUpdateResult.success;
      FlutterLogger.info('Flexible Update start result: $result', tag: _logTag);
      return success;
    } catch (e, stack) {
      FlutterLogger.error(
        'Flexible In-App Update failed: $e',
        tag: _logTag,
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Completes a previously downloaded Flexible update by restarting the app.
  static Future<bool> completeFlexibleUpdate() async {
    if (!isSupported) return false;

    try {
      FlutterLogger.info(
        'Completing Flexible In-App Update (restarting app)...',
        tag: _logTag,
      );
      await InAppUpdate.completeFlexibleUpdate();
      return true;
    } catch (e, stack) {
      FlutterLogger.error(
        'Failed to complete Flexible In-App Update: $e',
        tag: _logTag,
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Starts an Immediate in-app update flow.
  ///
  /// Immediate updates display a full-screen UX blocking user interaction until the update is downloaded and installed.
  static Future<bool> performImmediateUpdate() async {
    if (!isSupported) return false;

    try {
      FlutterLogger.info('Starting Immediate In-App Update...', tag: _logTag);
      final result = await InAppUpdate.performImmediateUpdate();
      final success = result == AppUpdateResult.success;
      FlutterLogger.info('Immediate Update result: $result', tag: _logTag);
      return success;
    } catch (e, stack) {
      FlutterLogger.error(
        'Immediate In-App Update failed: $e',
        tag: _logTag,
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Automatic update workflow helper.
  ///
  /// Checks for available updates and automatically performs either [performImmediateUpdate]
  /// or [startFlexibleUpdate] based on Google Play Store recommendation or developer preference.
  static Future<void> autoCheckAndUpdate({bool preferImmediate = false}) async {
    if (!isSupported) return;

    final info = await checkForUpdate();
    if (info == null || !info.updateAvailable) return;

    if (preferImmediate && info.immediateUpdateAllowed) {
      await performImmediateUpdate();
    } else if (info.flexibleUpdateAllowed) {
      final started = await startFlexibleUpdate();
      if (started) {
        await completeFlexibleUpdate();
      }
    } else if (info.immediateUpdateAllowed) {
      await performImmediateUpdate();
    }
  }
}
