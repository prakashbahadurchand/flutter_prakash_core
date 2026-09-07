import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_prakash_core_platform_interface.dart';

/// An implementation of [FpCorePlatform] that uses method channels.
class MethodChannelFpCore extends FpCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_prakash_core');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
