import 'flutter_prakash_platform_interface.dart';

/// Top-level interface for native plugin operations in Flutter Prakash.
class FlutterPrakashPlugin {
  const FlutterPrakashPlugin._();

  /// Returns the host platform version string (e.g. Android SDK / iOS version).
  static Future<String?> getPlatformVersion() {
    return FlutterPrakashPlatform.instance.getPlatformVersion();
  }
}
