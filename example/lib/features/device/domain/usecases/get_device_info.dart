import 'package:flutter_prakash/core.dart';

import '../entities/device_info.dart';
import '../repositories/device_info_repository.dart';

/// Use case that orchestrates fetching [DeviceInfo] through the repository.
///
/// Clean Architecture **domain** layer: high-level business rule expressed as
/// a single, testable object.
class GetDeviceInfo {
  final DeviceInfoRepository repository;

  const GetDeviceInfo(this.repository);

  Future<Result<DeviceInfo>> call() => repository.fetchDeviceInfo();
}