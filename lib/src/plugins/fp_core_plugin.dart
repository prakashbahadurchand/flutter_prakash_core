import 'flutter_prakash_core_platform_interface.dart';

/// Top-level interface for native plugin operations in Flutter Prakash Core (FP).
class FpCorePlugin {
  const FpCorePlugin._();

  /// Returns the host platform version string (e.g. Android SDK / iOS version).
  static Future<String?> getPlatformVersion() {
    return FpCorePlatform.instance.getPlatformVersion();
  }
}

/// Typed alias conforming to the [Fp] naming convention.
typedef FpNativePlugin = FpCorePlugin;
