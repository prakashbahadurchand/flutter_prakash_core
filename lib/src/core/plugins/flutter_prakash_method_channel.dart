import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_prakash_platform_interface.dart';

/// An implementation of [FlutterPrakashPlatform] that uses method channels.
class MethodChannelFlutterPrakash extends FlutterPrakashPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_prakash');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
