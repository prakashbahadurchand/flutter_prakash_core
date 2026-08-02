import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/errors/exceptions.dart';
import '../platform/prakash_native_bridge.dart';

/// Location service built on [permission_handler] and the native platform
/// bridge.
///
/// Permission gates are handled here; the raw GPS coordinate is provided by the
/// native `getCurrentLocation` method (a `"lat,lng"` string). When the native
/// side cannot produce a fix it returns `"unavailable"`, which surfaces as a
/// clear [NativePlatformException] instead of silently failing.
class LocationService {
  LocationService({IPrakashNativeBridge? bridge})
    : _bridge = bridge ?? PrakashNativeBridge();

  final IPrakashNativeBridge _bridge;

  /// Whether location permission has already been granted.
  Future<bool> hasPermission() async {
    final status = await Permission.location.status;
    return status.isGranted || status.isLimited;
  }

  /// Requests location permission and returns whether it was granted.
  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    return status.isGranted || status.isLimited;
  }

  /// Resolves the current device location.
  Future<LatLng> getCurrentLocation() async {
    if (!(await requestPermission())) {
      throw const NativePlatformException('Location permission denied');
    }

    final raw = await _bridge.getCurrentLocation();
    return _parseLocation(raw);
  }

  LatLng _parseLocation(String raw) {
    if (raw == 'unavailable' || !raw.contains(',')) {
      throw const NativePlatformException(
        'Location unavailable on this device',
      );
    }
    final parts = raw.split(',');
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) {
      throw const NativePlatformException('Invalid location payload');
    }
    return LatLng(lat, lng);
  }
}
