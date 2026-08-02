import 'package:permission_handler/permission_handler.dart';

/// Centralized permission handling built on [permission_handler].
class PermissionService {
  const PermissionService._();

  /// Requests a set of [permissions] and returns the resulting grouped status.
  static Future<Map<Permission, PermissionStatus>> request(
    List<Permission> permissions,
  ) async {
    return permissions.request();
  }

  /// Requests a single permission and returns whether it is granted.
  static Future<bool> requestOne(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Whether a permission is already granted.
  static Future<bool> isGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Opens the app settings page.
  static Future<void> openSettings() => openAppSettings();

  /// Convenience group of frequently used observers.
  static Permission get location => Permission.location;
  static Permission get camera => Permission.camera;
  static Permission get microphone => Permission.microphone;
  static Permission get notifications => Permission.notification;
  static Permission get storage => Permission.storage;
  static Permission get photos => Permission.photos;
}
