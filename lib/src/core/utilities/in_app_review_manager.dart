import 'package:flutter/foundation.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';
import 'package:in_app_review/in_app_review.dart';

/// Manager for handling native In-App Reviews and Store Listings.
///
/// Wraps `in_app_review` to provide effortless rating prompts and direct app store links
/// across iOS, Android, and macOS.
class InAppReviewManager {
  InAppReviewManager._();

  static const String _logTag = 'IN_APP_REVIEW';
  static final InAppReview _inAppReview = InAppReview.instance;

  /// Checks if in-app review API is available on the current device.
  static Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    try {
      final available = await _inAppReview.isAvailable();
      return available;
    } catch (e, stack) {
      FlutterLogger.error(
        'Failed to check in-app review availability: $e',
        tag: _logTag,
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Requests a native in-app review dialog.
  ///
  /// Note: The OS determines whether to actually display the review popup based on quotas and rules.
  /// Set [fallbackToStoreListing] to `true` to automatically open the store page if in-app review is unavailable.
  static Future<void> requestReview({
    bool fallbackToStoreListing = false,
    String? appStoreId,
    String? microsoftStoreId,
  }) async {
    if (kIsWeb) return;

    try {
      final available = await _inAppReview.isAvailable();
      if (available) {
        FlutterLogger.info('Requesting in-app review prompt...', tag: _logTag);
        await _inAppReview.requestReview();
      } else if (fallbackToStoreListing) {
        FlutterLogger.info(
          'In-app review unavailable; falling back to store listing.',
          tag: _logTag,
        );
        await openStoreListing(
          appStoreId: appStoreId,
          microsoftStoreId: microsoftStoreId,
        );
      } else {
        FlutterLogger.warning(
          'In-app review is not available on this device/platform.',
          tag: _logTag,
        );
      }
    } catch (e, stack) {
      FlutterLogger.error(
        'Failed to request in-app review: $e',
        tag: _logTag,
        error: e,
        stackTrace: stack,
      );
      if (fallbackToStoreListing) {
        await openStoreListing(
          appStoreId: appStoreId,
          microsoftStoreId: microsoftStoreId,
        );
      }
    }
  }

  /// Opens the app's official store page (Google Play Store, Apple App Store, or Mac App Store).
  ///
  /// Pass [appStoreId] for iOS/macOS (e.g. `'123456789'`).
  /// Pass [microsoftStoreId] for Windows if applicable.
  static Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {
    if (kIsWeb) return;

    try {
      FlutterLogger.info('Opening app store listing...', tag: _logTag);
      await _inAppReview.openStoreListing(
        appStoreId: appStoreId,
        microsoftStoreId: microsoftStoreId,
      );
    } catch (e, stack) {
      FlutterLogger.error(
        'Failed to open store listing: $e',
        tag: _logTag,
        error: e,
        stackTrace: stack,
      );
    }
  }
}
