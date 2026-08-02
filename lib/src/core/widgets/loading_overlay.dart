import 'dart:async';
import 'package:flutter/material.dart';

/// A customizable, static, full-screen loading overlay.
///
/// Prevents user interaction and back navigation while displayed.
/// Automatically hides after a maximum specified duration (default 15 seconds).
class LoadingOverlay {
  LoadingOverlay._();

  static OverlayEntry? _overlayEntry;
  static Timer? _autoHideTimer;

  /// Global key to access root navigator overlay without passing [BuildContext].
  ///
  /// For standard [MaterialApp]:
  /// `MaterialApp(navigatorKey: LoadingOverlay.navigatorKey)`
  ///
  /// For `auto_route` ([MaterialApp.router]):
  /// `MaterialApp.router(routerDelegate: _appRouter.delegate(navigatorKey: LoadingOverlay.navigatorKey))`
  /// or set custom key via `LoadingOverlay.navigatorKey = _appRouter.navigatorKey`.
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Whether the loading overlay is currently visible.
  static bool get isShowing => _overlayEntry != null;

  /// Shows the full-screen loading overlay without requiring a [BuildContext].
  ///
  /// - [autoHideInSeconds]: Optional duration in seconds before automatically hiding (defaults to 15 seconds).
  /// - [widget]: Optional custom loading widget (defaults to [CircularProgressIndicator.adaptive]).
  /// - [barrierColor]: Background color (defaults to black with 50% opacity).
  /// - [barrierDismissible]: Whether tapping outside dismisses the overlay (defaults to `false`).
  static void show({
    int? autoHideInSeconds = 15,
    Widget? widget,
    Color? barrierColor,
    bool barrierDismissible = false,
  }) {
    hide(); // Dismiss any existing overlay before showing a new one

    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return PopScope(
          canPop: false, // Prevents back navigation while loading
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                ModalBarrier(
                  color: barrierColor ?? Colors.black.withValues(alpha: 0.5),
                  dismissible: barrierDismissible,
                  onDismiss: barrierDismissible ? hide : null,
                ),
                Center(
                  child: widget ?? const CircularProgressIndicator.adaptive(),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);

    if (autoHideInSeconds != null && autoHideInSeconds > 0) {
      _autoHideTimer = Timer(Duration(seconds: autoHideInSeconds), hide);
    }
  }

  /// Hides and disposes the current loading overlay if visible.
  static void hide() {
    _autoHideTimer?.cancel();
    _autoHideTimer = null;

    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayEntry = null;
    }
  }
}
