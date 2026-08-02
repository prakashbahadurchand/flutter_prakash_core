import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/device_info.dart';
import '../../domain/repositories/device_info_repository.dart';

/// Clean Architecture **data** layer implementation of [DeviceInfoRepository].
///
/// Adapts the platform plug-in (native bridge + location/permission services)
/// into the domain contract, mapping low-level exceptions to [Result].
class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final PrakashNativeBridge _bridge;
  final LocationService _location;

  DeviceInfoRepositoryImpl(this._bridge, this._location);

  @override
  Future<Result<DeviceInfo>> fetchDeviceInfo() async {
    try {
      final version = await _bridge.getPlatformVersion();
      final model = await _bridge.getDeviceModel();

      final granted = await _location.hasPermission();
      double? lat;
      double? lng;
      if (granted) {
        final fix = await _safeLocationFix();
        lat = fix?.latitude;
        lng = fix?.longitude;
      }

      return Result.success(
        DeviceInfo(
          platformVersion: version,
          deviceModel: model,
          locationGranted: granted,
          latitude: lat,
          longitude: lng,
        ),
      );
    } catch (_) {
      return Result.failure(
        const NativePlatformFailure('Unable to read device info'),
      );
    }
  }

  /// Resolves a geographic fix when the OS has one, otherwise `null`.
  /// `getCurrentLocation()` yields a native `"unavailable"` signal otherwise.
  Future<LatLng?> _safeLocationFix() async {
    try {
      return await _location.getCurrentLocation();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    return _location.requestPermission();
  }
}