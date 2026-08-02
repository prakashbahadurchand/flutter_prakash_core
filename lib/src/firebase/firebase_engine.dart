import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../core/result/result.dart';
import '../core/errors/failures.dart';

class FirebaseEngineConfig {
  final bool enableAuth;
  final bool enableFirestore;
  final bool enableMessaging;
  final bool enableCrashlytics;
  final bool enableRemoteConfig;

  const FirebaseEngineConfig({
    this.enableAuth = true,
    this.enableFirestore = true,
    this.enableMessaging = true,
    this.enableCrashlytics = true,
    this.enableRemoteConfig = true,
  });
}

class FirebaseEngine {
  static Future<void> initialize({
    FirebaseEngineConfig config = const FirebaseEngineConfig(),
  }) async {
    await Firebase.initializeApp();

    if (config.enableCrashlytics && !kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    }

    if (config.enableMessaging) {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
    }
  }

  // Firestore Generic Helper
  static Future<Result<List<Map<String, dynamic>>>> getCollection(
    String collectionPath,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .get();
      final data = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
      return Result.success(data);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  // Remote Config Helper
  static Future<String> getRemoteString(String key) async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getString(key);
  }
}
