import 'package:equatable/equatable.dart';

import '../domain/entities/device_info.dart';

/// Clean Architecture **application** layer state for the device feature.
sealed class DeviceInfoState extends Equatable {
  const DeviceInfoState();

  @override
  List<Object?> get props => const [];
}

class DeviceInfoLoading extends DeviceInfoState {
  const DeviceInfoLoading();
}

class DeviceInfoLoaded extends DeviceInfoState {
  final DeviceInfo info;

  const DeviceInfoLoaded(this.info);

  @override
  List<Object?> get props => [info];
}

class DeviceInfoError extends DeviceInfoState {
  final String message;

  const DeviceInfoError(this.message);

  @override
  List<Object?> get props => [message];
}