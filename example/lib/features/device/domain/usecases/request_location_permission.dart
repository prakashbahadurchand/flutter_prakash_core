import '../../../device/domain/repositories/device_info_repository.dart';

/// Use case that requests location permission.
///
/// Clean Architecture **domain** layer.
class RequestLocationPermission {
  final DeviceInfoRepository repository;

  const RequestLocationPermission(this.repository);

  Future<bool> call() => repository.requestLocationPermission();
}