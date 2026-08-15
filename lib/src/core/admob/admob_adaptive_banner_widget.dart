import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Helper widget to easily load and display Adaptive Banner Ads dynamically calculated from context width.
class AdMobAdaptiveBannerWidget extends StatefulWidget {
  const AdMobAdaptiveBannerWidget({
    required this.adUnitId,
    super.key,
    this.padding = EdgeInsets.zero,
    this.placeholder,
  });

  final String adUnitId;
  final EdgeInsetsGeometry padding;
  final Widget? placeholder;

  @override
  State<AdMobAdaptiveBannerWidget> createState() =>
      _AdMobAdaptiveBannerWidgetState();
}

class _AdMobAdaptiveBannerWidgetState extends State<AdMobAdaptiveBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  AdSize? _adSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdaptiveAd();
  }

  Future<void> _loadAdaptiveAd() async {
    final width = MediaQuery.of(context).size.width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);

    if (size == null) return;

    setState(() {
      _adSize = size;
    });

    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _bannerAd = null;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null && _adSize != null) {
      return Padding(
        padding: widget.padding,
        child: SizedBox(
          width: _adSize!.width.toDouble(),
          height: _adSize!.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    return widget.placeholder ?? const SizedBox.shrink();
  }
}
