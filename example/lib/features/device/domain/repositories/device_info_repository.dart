import 'package:flutter_prakash/core.dart';

import '../entities/device_info.dart';

/// Contract for obtaining device/platform information.
///
/// Clean Architecture **domain** layer: the definition of the repository is
/// owned by the domain and implemented in the data layer, keeping the domain
/// free of platform specifics.
abstract class DeviceInfoRepository {
  /// Loads the current device info. Returns `Result.success` with the entity
  /// when available, or a `Result.failure` (e.g. [`NativePlatformFailure`])
  /// when the native bridge is unavailable.
  Future<Result<DeviceInfo>> fetchDeviceInfo();

  /// Requests location permission. Returns `true` if granted.
  Future<bool> requestLocationPermission();
}