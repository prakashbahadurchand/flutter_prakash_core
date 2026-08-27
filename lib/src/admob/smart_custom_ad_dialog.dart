import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admob/ad_icon.dart';
import 'package:flutter_prakash_core/src/admob/custom_ad_model.dart';

/// Helper widget to render custom app icon safely whether it's an asset, network URL, or placeholder icon.
class CustomAdIconWidget extends StatelessWidget {
  const CustomAdIconWidget({
    required this.ad,
    super.key,
    this.width = 48,
    this.height = 48,
    this.borderRadius = 8,
  });

  final CustomAdModel ad;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (ad.appIconPath.isEmpty) {
      child = Container(
        width: width,
        height: height,
        color: ad.primaryColor.withValues(alpha: 0.1),
        child: Icon(
          Icons.apps_rounded,
          color: ad.primaryColor,
          size: width * 0.6,
        ),
      );
    } else if (ad.isAssetImage) {
      child = Image.asset(
        ad.appIconPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: ad.primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.apps_rounded,
            color: ad.primaryColor,
            size: width * 0.6,
          ),
        ),
      );
    } else {
      child = Image.network(
        ad.appIconPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: ad.primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.apps_rounded,
            color: ad.primaryColor,
            size: width * 0.6,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: child,
    );
  }
}

/// Modal dialog displaying full app promotional details with instant store download button.
class SmartCustomAdDialog extends StatelessWidget {
  const SmartCustomAdDialog({required this.ad, super.key});

  final CustomAdModel ad;

  /// Shows the dialog.
  static Future<void> show(BuildContext context, CustomAdModel ad) {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => SmartCustomAdDialog(ad: ad),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ad.primaryColor, width: 2),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ad.headerInfo,
              style: theme.textTheme.titleMedium?.copyWith(
                color: ad.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            AdIcon.fromCustomAd(ad, width: 64, height: 64, borderRadius: 12),
            const SizedBox(height: 10),
            Text(
              ad.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              ad.appMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ad.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ad.appDetails,
              textAlign: TextAlign.justify,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ad.primaryColor),
                  ),
                  child: Text(ad.dialogOkText),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ad.openStore();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ad.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text(ad.dialogDownloadText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
