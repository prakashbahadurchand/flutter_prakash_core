import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';

/// Firebase Remote Config manager for remote feature flags, dynamic configuration,
/// defaults, and fetch/activate workflows.
class FirebaseRemoteConfigManager {
  FirebaseRemoteConfigManager._();

  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  /// Initializes Remote Config settings, default values, and fetches initial configuration.
  static Future<void> initialize({
    Map<String, dynamic>? defaults,
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval = const Duration(hours: 1),
  }) async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );

    if (defaults != null) {
      await _remoteConfig.setDefaults(defaults);
    }

    try {
      final updated = await _remoteConfig.fetchAndActivate();
      FlutterLogger.info(
        'Remote Config initialized (fetchAndActivate: $updated)',
        tag: 'REMOTE_CONFIG',
      );
    } catch (e) {
      FlutterLogger.error('Failed to fetch Remote Config: $e', tag: 'REMOTE_CONFIG');
    }
  }

  /// Gets a boolean parameter.
  static bool getBool(String key) => _remoteConfig.getBool(key);

  /// Gets a string parameter.
  static String getString(String key) => _remoteConfig.getString(key);

  /// Gets an integer parameter.
  static int getInt(String key) => _remoteConfig.getInt(key);

  /// Gets a double parameter.
  static double getDouble(String key) => _remoteConfig.getDouble(key);
}
