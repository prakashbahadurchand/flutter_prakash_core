import 'package:flutter/material.dart';

/// A static utility for displaying non-blocking, beautifully styled Toast notifications
/// using [ScaffoldMessengerState] without requiring a direct [BuildContext].
///
/// Setup for standard [MaterialApp]:
/// ```dart
/// MaterialApp(
///   scaffoldMessengerKey: Toast.scaffoldMessengerKey,
/// )
/// ```
///
/// Setup for `auto_route` ([MaterialApp.router]):
/// ```dart
/// MaterialApp.router(
///   scaffoldMessengerKey: Toast.scaffoldMessengerKey,
///   routerConfig: _appRouter.config(),
/// )
/// ```
class Toast {
  Toast._();

  /// Global key to manage [ScaffoldMessengerState] without requiring [BuildContext].
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Shows a success toast notification.
  static void success(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    VoidCallback? onAction,
    String? actionLabel,
    DismissDirection dismissDirection = DismissDirection.down,
  }) {
    _show(
      message: message,
      title: title,
      backgroundColor: const Color(0xFF2E7D32), // Dark Green
      icon: Icons.check_circle_outline_rounded,
      duration: duration,
      behavior: behavior,
      onAction: onAction,
      actionLabel: actionLabel,
      dismissDirection: dismissDirection,
    );
  }

  /// Shows an error toast notification.
  static void error(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    VoidCallback? onAction,
    String? actionLabel,
    DismissDirection dismissDirection = DismissDirection.down,
  }) {
    _show(
      message: message,
      title: title,
      backgroundColor: const Color(0xFFD32F2F), // Dark Red
      icon: Icons.error_outline_rounded,
      duration: duration,
      behavior: behavior,
      onAction: onAction,
      actionLabel: actionLabel,
      dismissDirection: dismissDirection,
    );
  }

  /// Shows a warning toast notification.
  static void warning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    VoidCallback? onAction,
    String? actionLabel,
    DismissDirection dismissDirection = DismissDirection.down,
  }) {
    _show(
      message: message,
      title: title,
      backgroundColor: const Color(0xFFED6C02), // Dark Orange
      icon: Icons.warning_amber_rounded,
      duration: duration,
      behavior: behavior,
      onAction: onAction,
      actionLabel: actionLabel,
      dismissDirection: dismissDirection,
    );
  }

  /// Shows an informational toast notification.
  static void info(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    VoidCallback? onAction,
    String? actionLabel,
    DismissDirection dismissDirection = DismissDirection.down,
  }) {
    _show(
      message: message,
      title: title,
      backgroundColor: const Color(0xFF0288D1), // Dark Blue
      icon: Icons.info_outline_rounded,
      duration: duration,
      behavior: behavior,
      onAction: onAction,
      actionLabel: actionLabel,
      dismissDirection: dismissDirection,
    );
  }

  /// Hides any currently active toast immediately.
  static void dismiss() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  /// Internal helper method to build and display a modern, polished [SnackBar].
  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    VoidCallback? onAction,
    String? actionLabel,
    DismissDirection dismissDirection = DismissDirection.down,
  }) {
    final messengerState = scaffoldMessengerKey.currentState;
    if (messengerState == null) return;

    messengerState.hideCurrentSnackBar();

    final snackBar = SnackBar(
      duration: duration,
      behavior: behavior,
      elevation: 6,
      backgroundColor: backgroundColor,
      dismissDirection: dismissDirection,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: behavior == SnackBarBehavior.floating
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null && title.trim().isNotEmpty) ...[
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      action: (onAction != null && actionLabel != null)
          ? SnackBarAction(
              label: actionLabel.toUpperCase(),
              textColor: Colors.white,
              onPressed: onAction,
            )
          : null,
    );

    messengerState.showSnackBar(snackBar);
  }
}

/// Alias for [Toast] to match file name and ensure backwards compatibility.
typedef ToastOverlay = Toast;
