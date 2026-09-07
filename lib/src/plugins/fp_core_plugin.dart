import 'fp_core_platform_interface.dart';

/// Top-level interface for native plugin operations in Flutter Prakash Core (FP).
///
/// Provides static convenience methods that delegate to the platform-specific
/// implementation registered via [FpCorePlatform].
class FpCorePlugin {
  const FpCorePlugin._();

  /// Returns the host platform version string (e.g. Android SDK / iOS version).
  static Future<String?> getPlatformVersion() {
    return FpCorePlatform.instance.getPlatformVersion();
  }

  /// Returns the device model string (e.g. "Samsung Galaxy S24" / "iPhone 16 Pro").
  static Future<String?> getDeviceModel() {
    return FpCorePlatform.instance.getDeviceModel();
  }

  /// Returns the last known device location as "latitude,longitude" or null.
  ///
  /// Requires location permissions to be granted by the user.
  /// Returns null if permissions are denied or location is unavailable.
  static Future<String?> getCurrentLocation() {
    return FpCorePlatform.instance.getCurrentLocation();
  }
}

/// Typed alias conforming to the [Fp] naming convention.
typedef FpNativePlugin = FpCorePlugin;
