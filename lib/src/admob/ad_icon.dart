import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admob/custom_ad_model.dart';
import 'package:flutter_prakash_core/src/admob/smart_custom_ad_dialog.dart';

/// Styled App Icon wrapper with an overlay "Ad" badge and subtle shadow.
class AdIcon extends StatelessWidget {
  const AdIcon({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(4.0),
    this.borderRadius = 8.0,
    this.badgeText = 'Ad ',
    this.badgeTextColor,
    this.shadowColor,
    this.size,
  });

  /// Factory constructor to directly render an [AdIcon] from a [CustomAdModel].
  factory AdIcon.fromCustomAd(
    CustomAdModel ad, {
    Key? key,
    double width = 48,
    double height = 48,
    double borderRadius = 8,
    EdgeInsetsGeometry padding = const EdgeInsets.all(4.0),
  }) {
    return AdIcon(
      key: key,
      padding: padding,
      borderRadius: borderRadius,
      child: CustomAdIconWidget(
        ad: ad,
        width: width,
        height: height,
        borderRadius: borderRadius,
      ),
    );
  }

  /// Child widget (typically an [Image.asset], [Image.network], or icon).
  final Widget child;

  /// Outer padding around the icon container.
  final EdgeInsetsGeometry padding;

  /// Corner radius of the icon container and badge.
  final double borderRadius;

  /// Text shown inside the top-left badge.
  final String badgeText;

  /// Text color for the top-left badge (default: deep red).
  final Color? badgeTextColor;

  /// Shadow color for the icon container.
  final Color? shadowColor;

  /// Optional fixed size override.
  final double? size;

  @override
  Widget build(BuildContext context) {
    final effectiveShadow = shadowColor ?? Colors.pink.shade900;
    final effectiveBadgeColor = badgeTextColor ?? Colors.red.shade900;

    Widget content = AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          // Fill Icon container:
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(top: 4, left: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: effectiveShadow,
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: child,
            ),
          ),

          // Ad Text Badge:
          Positioned(
            top: 2,
            left: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.zero,
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.circular(borderRadius),
                ),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 12,
                  color: effectiveBadgeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (size != null) {
      content = SizedBox(width: size, height: size, child: content);
    }

    return Padding(padding: padding, child: content);
  }
}
