import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_prakash_core_method_channel.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
