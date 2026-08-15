import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Enum representing the 4 corner positions for [DebugBanner].
enum DebugBannerPosition { topLeft, topRight, bottomLeft, bottomRight }

/// Supported app flavors: `dev` and `prod`.
enum AppFlavor { dev, prod }

/// A customizable, flavor-aware Debug Banner widget that displays build mode (D for Debug, R for Release, P for Profile)
/// alongside the specified environment flavor (e.g. `DEV (D)`, `DEV (R)`, `PROD (D)`).
///
/// Banner is **never shown** in `PROD` release builds.
/// Supports 4 corner positions: `topLeft`, `topRight`, `bottomLeft`, and `bottomRight`.
///
/// ### Example Usage:
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:flutter_prakash/flutter_prakash.dart';
///
/// void main() {
///   runApp(const MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       debugShowCheckedModeBanner: false, // Hide default banner
///       builder: (context, child) {
///         return DebugBanner(
///           flavor: AppFlavor.dev, // AppFlavor.dev or AppFlavor.prod
///           position: DebugBannerPosition.topRight,
///           child: child ?? const SizedBox.shrink(),
///         );
///       },
///       home: const HomeScreen(),
///     );
///   }
/// }
/// ```
class DebugBanner extends StatelessWidget {
  /// The child widget wrapped by the banner (typically the navigator child from MaterialApp.builder).
  final Widget child;

  /// The active app flavor (`AppFlavor.dev` or `AppFlavor.prod`).
  final AppFlavor flavor;

  /// Position of the corner banner (`topLeft`, `topRight`, `bottomLeft`, `bottomRight`).
  final DebugBannerPosition position;

  /// Custom banner color. If null, automatically assigned based on flavor (`dev` -> red, `prod` -> blue).
  final Color? color;

  /// Custom text style for the banner text.
  final TextStyle? textStyle;

  /// Override for debug mode check (useful for testing or forced display).
  final bool? isDebugOverride;

  const DebugBanner({
    super.key,
    required this.child,
    required this.flavor,
    this.position = DebugBannerPosition.bottomRight,
    this.color,
    this.textStyle,
    this.isDebugOverride,
  });

  /// Resolves the mode tag: `(D)` for Debug, `(R)` for Release, `(P)` for Profile.
  String get _modeTag {
    if (kDebugMode) return '(D)';
    if (kProfileMode) return '(P)';
    return '(R)';
  }

  /// Full text to display on banner (e.g. `DEV (D)` or `PROD (D)`).
  String get bannerText => '${flavor.name.toUpperCase()} $_modeTag';

  /// Automatic color selection if custom [color] is not provided.
  Color get _bannerColor {
    if (color != null) return color!;
    return switch (flavor) {
      AppFlavor.dev => Colors.red.shade700,
      AppFlavor.prod => Colors.blue.shade800,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDebug = isDebugOverride ?? kDebugMode;

    // Never show banner in PROD release builds
    if (flavor == AppFlavor.prod && kReleaseMode && isDebugOverride == null) {
      return child;
    }

    // Do not show banner in release mode unless specifically forced via isDebugOverride
    if (!isDebug && isDebugOverride == null && flavor == AppFlavor.prod) {
      return child;
    }

    final bannerLocation = switch (position) {
      DebugBannerPosition.topLeft => BannerLocation.topStart,
      DebugBannerPosition.topRight => BannerLocation.topEnd,
      DebugBannerPosition.bottomLeft => BannerLocation.bottomStart,
      DebugBannerPosition.bottomRight => BannerLocation.bottomEnd,
    };

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        message: bannerText,
        location: bannerLocation,
        color: _bannerColor,
        textStyle:
            textStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 9.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
        child: child,
      ),
    );
  }
}
