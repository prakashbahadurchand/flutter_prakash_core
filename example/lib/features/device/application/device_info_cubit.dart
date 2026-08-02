import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/device_info.dart';
import '../domain/usecases/get_device_info.dart';
import '../domain/usecases/request_location_permission.dart';
import 'device_info_state.dart';

/// Clean Architecture **application** layer for the device feature.
///
/// Bridges the domain use cases to the presentation layer, exposing the
/// current [DeviceInfoState] reactively.
class DeviceInfoCubit extends Cubit<DeviceInfoState> {
  final GetDeviceInfo _getDeviceInfo;
  final RequestLocationPermission _requestLocationPermission;

  DeviceInfoCubit(this._getDeviceInfo, this._requestLocationPermission)
    : super(const DeviceInfoLoading());

  Future<void> load() async {
    emit(const DeviceInfoLoading());
    final result = await _getDeviceInfo();
    result.fold(
      onSuccess: (info) => emit(DeviceInfoLoaded(info)),
      onFailure: (failure) => emit(DeviceInfoError(failure.message)),
    );
  }

  Future<void> requestLocation() async {
    final current = state;
    if (current is! DeviceInfoLoaded) return;
    final granted = await _requestLocationPermission();
    emit(
      DeviceInfoLoaded(
        DeviceInfo(
          platformVersion: current.info.platformVersion,
          deviceModel: current.info.deviceModel,
          locationGranted: granted,
          latitude: current.info.latitude,
          longitude: current.info.longitude,
        ),
      ),
    );
  }
}