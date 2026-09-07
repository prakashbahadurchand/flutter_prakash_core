import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fp_core_method_channel.dart';

/// The interface that platform-specific implementations of `flutter_prakash_core` must extend.
///
/// Platform implementations should set this with their own platform-specific class
/// that extends [FpCorePlatform] when they register themselves.
abstract class FpCorePlatform extends PlatformInterface {
  /// Constructs a FpCorePlatform.
  FpCorePlatform() : super(token: _token);

  static final Object _token = Object();

  static FpCorePlatform _instance = MethodChannelFpCore();

  /// The default instance of [FpCorePlatform] to use.
  ///
  /// Defaults to [MethodChannelFpCore].
  static FpCorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FpCorePlatform] when
  /// they register themselves.
  static set instance(FpCorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the host platform version string (e.g. Android SDK / iOS version).
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Returns the device model string (e.g. "Samsung Galaxy S24" / "iPhone 16 Pro").
  Future<String?> getDeviceModel() {
    throw UnimplementedError('getDeviceModel() has not been implemented.');
  }

  /// Returns the last known device location as "latitude,longitude" or null.
  Future<String?> getCurrentLocation() {
    throw UnimplementedError('getCurrentLocation() has not been implemented.');
  }
}
