import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_prakash_method_channel.dart';

abstract class FlutterPrakashPlatform extends PlatformInterface {
  /// Constructs a FlutterPrakashPlatform.
  FlutterPrakashPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPrakashPlatform _instance = MethodChannelFlutterPrakash();

  /// The default instance of [FlutterPrakashPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPrakash].
  static FlutterPrakashPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPrakashPlatform] when
  /// they register themselves.
  static set instance(FlutterPrakashPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
