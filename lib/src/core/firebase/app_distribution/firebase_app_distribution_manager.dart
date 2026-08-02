import 'package:firebase_app_distribution/firebase_app_distribution.dart'
    as app_dist;
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';

/// Firebase App Distribution manager for tester authentication and in-app update checks.
class FirebaseAppDistributionManager {
  FirebaseAppDistributionManager._();

  /// Check if a tester is signed in.
  static Future<bool> isTesterSignedIn() async {
    return app_dist.isTesterSignedIn();
  }

  /// Signs in the tester for app distribution releases.
  static Future<void> signInTester() async {
    try {
      await app_dist.signInTester();
      FlutterLogger.info('Tester signed in to App Distribution', tag: 'APP_DISTRIBUTION');
    } catch (e, stack) {
      FlutterLogger.error(
        'App Distribution tester sign-in failed: $e',
        tag: 'APP_DISTRIBUTION',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Signs out the tester.
  static Future<void> signOutTester() async {
    await app_dist.signOutTester();
    FlutterLogger.info('Tester signed out from App Distribution', tag: 'APP_DISTRIBUTION');
  }

  /// Checks for new app releases and prompts the tester to update if available.
  static Future<void> checkForUpdate() async {
    try {
      await app_dist.updateIfNewReleaseAvailable();
    } catch (e, stack) {
      FlutterLogger.error(
        'App Distribution update check failed: $e',
        tag: 'APP_DISTRIBUTION',
        error: e,
        stackTrace: stack,
      );
    }
  }
}
