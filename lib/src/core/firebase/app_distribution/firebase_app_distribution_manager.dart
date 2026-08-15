// import 'package:firebase_app_distribution/firebase_app_distribution.dart'
//     as app_dist;
// import 'package:flutter/foundation.dart';
// import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';

// /// Firebase App Distribution manager for tester authentication and in-app release update checks.
// ///
// /// Designed to streamline pre-release testing by managing tester sign-ins,
// /// checking for new releases, and handling update prompts gracefully across supported platforms.
// class FirebaseAppDistributionManager {
//   FirebaseAppDistributionManager._();

//   static const String _logTag = 'APP_DISTRIBUTION';

//   /// Returns `true` if App Distribution is supported on the current platform (Android & iOS).
//   static bool get isSupported =>
//       !kIsWeb &&
//       (defaultTargetPlatform == TargetPlatform.android ||
//           defaultTargetPlatform == TargetPlatform.iOS);

//   /// Checks if a tester is currently signed in to App Distribution.
//   ///
//   /// Returns `false` on unsupported platforms or if an error occurs.
//   static Future<bool> isTesterSignedIn() async {
//     if (!isSupported) {
//       FlutterLogger.debug(
//         'App Distribution is not supported on this platform.',
//         tag: _logTag,
//       );
//       return false;
//     }
//     try {
//       final isSignedIn = await app_dist.isTesterSignedIn();
//       return isSignedIn;
//     } catch (e, stack) {
//       FlutterLogger.error(
//         'Failed to check tester sign-in status: $e',
//         tag: _logTag,
//         error: e,
//         stackTrace: stack,
//       );
//       return false;
//     }
//   }

//   /// Signs in the tester for app distribution releases.
//   ///
//   /// Prompts the browser/authentication flow for tester authentication.
//   static Future<void> signInTester() async {
//     if (!isSupported) return;

//     try {
//       await app_dist.signInTester();
//       FlutterLogger.info(
//         'Tester signed in to App Distribution successfully.',
//         tag: _logTag,
//       );
//     } catch (e, stack) {
//       FlutterLogger.error(
//         'App Distribution tester sign-in failed: $e',
//         tag: _logTag,
//         error: e,
//         stackTrace: stack,
//       );
//     }
//   }

//   /// Signs out the currently logged-in tester.
//   static Future<void> signOutTester() async {
//     if (!isSupported) return;

//     try {
//       await app_dist.signOutTester();
//       FlutterLogger.info(
//         'Tester signed out from App Distribution.',
//         tag: _logTag,
//       );
//     } catch (e, stack) {
//       FlutterLogger.error(
//         'Failed to sign out tester from App Distribution: $e',
//         tag: _logTag,
//         error: e,
//         stackTrace: stack,
//       );
//     }
//   }

//   /// Checks for new app releases and prompts the tester to update if available.
//   ///
//   /// If a new release is available on App Distribution, this method prompts the tester
//   /// with an in-app dialog to download and install the update.
//   static Future<void> checkForUpdate() async {
//     if (!isSupported) return;

//     try {
//       FlutterLogger.info(
//         'Checking for new App Distribution release...',
//         tag: _logTag,
//       );
//       await app_dist.updateIfNewReleaseAvailable();
//     } catch (e, stack) {
//       FlutterLogger.error(
//         'App Distribution update check failed: $e',
//         tag: _logTag,
//         error: e,
//         stackTrace: stack,
//       );
//     }
//   }

//   /// Helper workflow method to automatically ensure tester sign-in and check for updates.
//   ///
//   /// Useful during app startup in pre-release/staging/dev builds.
//   /// Set [onlyInDebugMode] to `true` if you only want this active during non-production/debug builds.
//   static Future<void> autoCheckReleaseUpdate({
//     bool onlyInDebugMode = false,
//   }) async {
//     if (!isSupported) return;
//     if (onlyInDebugMode && !kDebugMode) return;

//     final signedIn = await isTesterSignedIn();
//     if (!signedIn) {
//       FlutterLogger.info(
//         'Tester not signed in. Initiating sign-in flow for App Distribution update check...',
//         tag: _logTag,
//       );
//       await signInTester();
//     }

//     await checkForUpdate();
//   }
// }
