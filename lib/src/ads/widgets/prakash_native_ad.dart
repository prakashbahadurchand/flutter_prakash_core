import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Loads and renders a native ad using the SDK bundled native template.
///
/// Self-contained lifecycle: loads on [initState] and disposes on [dispose].
class PrakashNativeAd extends StatefulWidget {
  final String adUnitId;
  final AdSize? adSize;
  final TemplateType templateType;
  final Color? cardBackgroundColor;
  final double cornerRadius;

  const PrakashNativeAd({
    super.key,
    required this.adUnitId,
    this.adSize,
    this.templateType = TemplateType.medium,
    this.cardBackgroundColor,
    this.cornerRadius = 12,
  });

  @override
  State<PrakashNativeAd> createState() => _PrakashNativeAdState();
}

class _PrakashNativeAdState extends State<PrakashNativeAd> {
  NativeAd? _ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final template = NativeTemplateStyle(
      templateType: widget.templateType,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.red,
        size: 13,
        backgroundColor: const Color(0xFFEF394E),
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black.withValues(alpha: 0.7),
        size: 12,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black,
        size: 15,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: Colors.black.withValues(alpha: 0.6),
        size: 12,
      ),
      mainBackgroundColor:
          widget.cardBackgroundColor ?? const Color(0xFFF8F8F8),
      cornerRadius: widget.cornerRadius,
    );

    final native = NativeAd(
      adUnitId: widget.adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(mediaAspectRatio: MediaAspectRatio.any),
      nativeTemplateStyle: template,
    );
    native.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_isLoaded || ad == null) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.cornerRadius + 4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      clipBehavior: Clip.antiAlias,
      child: AdWidget(ad: ad),
    );
  }
}
