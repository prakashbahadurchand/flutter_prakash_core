import 'package:flutter/material.dart';

/// An enterprise-grade, responsive Toast notification overlay system.
///
/// Designed to work seamlessly across Mobile, Tablet, and Desktop web/native apps
/// without requiring a [BuildContext] at the call site.
///
/// Setup for [MaterialApp]:
/// ```dart
/// MaterialApp(
///   scaffoldMessengerKey: Toast.scaffoldMessengerKey,
///   // ...
/// )
/// ```
///
/// Usage:
/// ```dart
/// Toast.success('Settings saved successfully!');
/// Toast.error('Failed to sync database', title: 'Connection Timeout');
/// ```
class Toast {
  Toast._();

  /// Global key used to manage [ScaffoldMessengerState] without explicit [BuildContext].
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Maximum allowed width for desktop and tablet toast cards.
  static const double _maxDesktopWidth = 400;

  /// Mobile breakpoint threshold (in logical pixels).
  static const double _mobileBreakpoint = 600;

  // ---------------------------------------------------------------------------
  // Public API Methods
  // ---------------------------------------------------------------------------

  /// Shows a success toast notification.
  static void success(
    String message, {
    BuildContext? context,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
    Alignment desktopAlignment = Alignment.topRight,
  }) {
    _show(
      context: context,
      message: message,
      title: title,
      backgroundColor: const Color(0xFF132A17), // Deep surface green
      borderColor: const Color(0xFF4CAF50), // Accent green
      iconColor: const Color(0xFF81C784),
      icon: Icons.check_circle_rounded,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
      desktopAlignment: desktopAlignment,
    );
  }

  /// Shows an error toast notification.
  static void error(
    String message, {
    BuildContext? context,
    String? title,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
    Alignment desktopAlignment = Alignment.topRight,
  }) {
    _show(
      context: context,
      message: message,
      title: title,
      backgroundColor: const Color(0xFF2D1515), // Deep surface red
      borderColor: const Color(0xFFE57373), // Accent red
      iconColor: const Color(0xFFEF5350),
      icon: Icons.error_rounded,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
      desktopAlignment: desktopAlignment,
    );
  }

  /// Shows a warning toast notification.
  static void warning(
    String message, {
    BuildContext? context,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
    Alignment desktopAlignment = Alignment.topRight,
  }) {
    _show(
      context: context,
      message: message,
      title: title,
      backgroundColor: const Color(0xFF2C2010), // Deep surface orange
      borderColor: const Color(0xFFFFB74D), // Accent orange
      iconColor: const Color(0xFFFF9800),
      icon: Icons.warning_rounded,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
      desktopAlignment: desktopAlignment,
    );
  }

  /// Shows an informational toast notification.
  static void info(
    String message, {
    BuildContext? context,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
    Alignment desktopAlignment = Alignment.topRight,
  }) {
    _show(
      context: context,
      message: message,
      title: title,
      backgroundColor: const Color(0xFF0F2332), // Deep surface blue
      borderColor: const Color(0xFF64B5F6), // Accent blue
      iconColor: const Color(0xFF4FC3F7),
      icon: Icons.info_rounded,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
      desktopAlignment: desktopAlignment,
    );
  }

  /// Immediately dismisses any active toast notification.
  static void dismiss() {
    scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
  }

  // ---------------------------------------------------------------------------
  // Internal Rendering Engine
  // ---------------------------------------------------------------------------

  static void _show({
    required String message,
    required Color backgroundColor,
    required Color borderColor,
    required Color iconColor,
    required IconData icon,
    BuildContext? context,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
    Alignment desktopAlignment = Alignment.topRight,
  }) {
    final messengerState = scaffoldMessengerKey.currentState;

    // Guard: Prevent execution if ScaffoldMessenger is missing or disposed
    if (messengerState == null || !messengerState.mounted) return;

    // Safely clear active notifications
    messengerState.removeCurrentSnackBar();

    // Determine current logical screen width safely
    final screenWidth = _getScreenWidth(context, messengerState);
    final isMobile = screenWidth < _mobileBreakpoint;

    // Calculate margins and swipe-to-dismiss behavior based on platform
    final EdgeInsets margin = _calculateMargin(
      screenWidth: screenWidth,
      isMobile: isMobile,
      desktopAlignment: desktopAlignment,
    );

    final DismissDirection dismissDirection = _calculateDismissDirection(
      isMobile: isMobile,
      desktopAlignment: desktopAlignment,
    );

    final snackBar = SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor:
          Colors.transparent, // Uses inner container surface decoration
      dismissDirection: dismissDirection,
      padding: EdgeInsets.zero,
      margin: margin,
      content: Align(
        alignment: isMobile ? Alignment.bottomCenter : desktopAlignment,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : _maxDesktopWidth,
          ),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor.withValues(alpha: 0.35)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 16,
                spreadRadius: -2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Badge Indicator
              Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),

              // Title and Body Text Group
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null && title.trim().isNotEmpty) ...[
                      Text(
                        title.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: -0.2,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                    ],
                    Text(
                      message.trim(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Button (Optional)
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    dismiss();
                    onAction();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: borderColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],

              // Desktop Explicit Close Button
              if (!isMobile) ...[
                const SizedBox(width: 6),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: dismiss,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withValues(alpha: 0.45),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    messengerState.showSnackBar(snackBar);
  }

  // ---------------------------------------------------------------------------
  // Helper Calculations
  // ---------------------------------------------------------------------------

  /// Calculates viewport width safely without throwing unmounted/null context exceptions.
  static double _getScreenWidth(
    BuildContext? context,
    ScaffoldMessengerState messengerState,
  ) {
    if (context != null) {
      final media = MediaQuery.maybeOf(context);
      if (media != null) return media.size.width;
    }

    if (messengerState.mounted) {
      final media = MediaQuery.maybeOf(messengerState.context);
      if (media != null) return media.size.width;
    }

    // Fallback using View platformDispatcher for Flutter Web/Desktop initializations
    final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    if (view != null) {
      return view.physicalSize.width / view.devicePixelRatio;
    }

    return 1200; // Sane fallback default (Desktop mode)
  }

  /// Determines horizontal and vertical margin positioning.
  static EdgeInsets _calculateMargin({
    required double screenWidth,
    required bool isMobile,
    required Alignment desktopAlignment,
  }) {
    if (isMobile) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    }

    final isTop =
        desktopAlignment == Alignment.topRight ||
        desktopAlignment == Alignment.topLeft ||
        desktopAlignment == Alignment.topCenter;

    return EdgeInsets.only(
      top: isTop ? 20 : 0,
      bottom: isTop ? 0 : 20,
      left: 20,
      right: 20,
    );
  }

  /// Configures swipe dismissal direction depending on screen placement.
  static DismissDirection _calculateDismissDirection({
    required bool isMobile,
    required Alignment desktopAlignment,
  }) {
    if (isMobile) return DismissDirection.down;

    if (desktopAlignment == Alignment.topRight ||
        desktopAlignment == Alignment.bottomRight) {
      return DismissDirection.endToStart;
    }

    return DismissDirection.startToEnd;
  }
}

/// Backwards compatibility alias
typedef ToastOverlay = Toast;
