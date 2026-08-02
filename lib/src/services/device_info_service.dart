import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Device / OS metadata facade built on [device_info_plus].
class DeviceInfoService {
  const DeviceInfoService._();

  static final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

  /// Android hardware/OS info (throws if not running on Android).
  static Future<AndroidDeviceInfo> get androidInfo => _plugin.androidInfo;

  /// iOS info (throws if not running on iOS).
  static Future<IosDeviceInfo> get iosInfo => _plugin.iosInfo;

  /// Best-effort readable device model across platforms.
  static Future<String> deviceModel() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final info = await _plugin.androidInfo;
        return '${info.brand} ${info.model}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final info = await _plugin.iosInfo;
        return info.utsname.machine;
      }
    } catch (_) {
      // ignore platform errors and fall through.
    }
    return 'Unknown device';
  }
}
