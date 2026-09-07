import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fp_core_platform_interface.dart';

/// An implementation of [FpCorePlatform] that uses method channels.
class MethodChannelFpCore extends FpCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  static const methodChannel = MethodChannel('flutter_prakash_core');

  @override
  Future<String?> getPlatformVersion() async {
    try {
      final version = await methodChannel.invokeMethod<String>(
        'getPlatformVersion',
      );
      return version;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<String?> getDeviceModel() async {
    try {
      final model = await methodChannel.invokeMethod<String>('getDeviceModel');
      return model;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  @override
  Future<String?> getCurrentLocation() async {
    try {
      final location = await methodChannel.invokeMethod<String>(
        'getCurrentLocation',
      );
      return location;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
