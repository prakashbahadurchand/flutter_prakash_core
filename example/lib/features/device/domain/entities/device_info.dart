/// Domain entity describing the device running the app.
///
/// Part of the Clean Architecture **domain** layer: pure Dart, no Flutter
/// imports, no dependencies on data sources or plug-ins.
class DeviceInfo {
  final String platformVersion;
  final String deviceModel;
  final bool locationGranted;
  final double? latitude;
  final double? longitude;

  const DeviceInfo({
    required this.platformVersion,
    required this.deviceModel,
    required this.locationGranted,
    this.latitude,
    this.longitude,
  });

  String get locationLabel {
    if (!locationGranted) return 'Permission not granted';
    if (latitude == null || longitude == null) return 'No fix available';
    return '$latitude, $longitude';
  }

  @override
  String toString() {
    return 'DeviceInfo(version: $platformVersion, model: $deviceModel, '
        'locationGranted: $locationGranted)';
  }
}