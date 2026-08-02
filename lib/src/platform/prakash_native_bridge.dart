import 'package:flutter/services.dart';

import '../core/errors/exceptions.dart';

/// Contract for the native platform bridge. Kept as an interface so it can be
/// replaced with a mocked/federated implementation in tests.
abstract interface class IPrakashNativeBridge {
  /// Invokes an arbitrary native method with optional arguments.
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]);

  /// Detects the native OS version string.
  Future<String> getPlatformVersion();

  /// Detects the human-readable native device model.
  Future<String> getDeviceModel();

  /// Resolves the last-known location as a `"lat,lng"` string, or
  /// `"unavailable"` when the native OS cannot provide one.
  Future<String> getCurrentLocation();
}

/// Default [IPrakashNativeBridge] backed by a single MethodChannel.
///
/// Extend the native Kotlin/Swift handlers to add capabilities; matching
/// methods become reachable from Dart through [invokeMethod].
class PrakashNativeBridge implements IPrakashNativeBridge {
  static const MethodChannel _channel = MethodChannel('flutter_prakash');

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on PlatformException catch (e) {
      throw NativePlatformException(
        e.message ?? 'Native Method Exception',
        code: e.code,
      );
    }
  }

  @override
  Future<String> getPlatformVersion() async {
    return await invokeMethod<String>('getPlatformVersion') ?? 'unknown';
  }

  @override
  Future<String> getDeviceModel() async {
    return await invokeMethod<String>('getDeviceModel') ?? 'unknown';
  }

  @override
  Future<String> getCurrentLocation() async {
    return await invokeMethod<String>('getCurrentLocation') ?? 'unavailable';
  }
}
