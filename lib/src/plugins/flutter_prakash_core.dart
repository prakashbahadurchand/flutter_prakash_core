import 'flutter_prakash_core_platform_interface.dart';

/// Top-level interface for native plugin operations in Flutter Prakash Core.
class FlutterPrakashCorePlugin {
  const FlutterPrakashCorePlugin._();

  /// Returns the host platform version string (e.g. Android SDK / iOS version).
  static Future<String?> getPlatformVersion() {
    return FlutterPrakashCorePlatform.instance.getPlatformVersion();
  }
}
