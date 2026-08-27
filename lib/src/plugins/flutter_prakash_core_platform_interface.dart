import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_prakash_core_method_channel.dart';

abstract class FlutterPrakashCorePlatform extends PlatformInterface {
  /// Constructs a FlutterPrakashCorePlatform.
  FlutterPrakashCorePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPrakashCorePlatform _instance =
      MethodChannelFlutterPrakashCore();

  /// The default instance of [FlutterPrakashCorePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPrakashCore].
  static FlutterPrakashCorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPrakashCorePlatform] when
  /// they register themselves.
  static set instance(FlutterPrakashCorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
