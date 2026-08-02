import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A widget that loads and displays an AdMob Banner Ad safely with loading & fallback indicators.
class AdMobBannerWidget extends StatefulWidget {
  const AdMobBannerWidget({
    required this.adUnitId,
    super.key,
    this.adSize = AdSize.banner,
    this.padding = EdgeInsets.zero,
    this.placeholder,
  });

  final String adUnitId;
  final AdSize adSize;
  final EdgeInsetsGeometry padding;
  final Widget? placeholder;

  @override
  State<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<AdMobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: widget.adSize,
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
  Widget build(BuildContext me) {
    if (_isLoaded && _bannerAd != null) {
      return Padding(
        padding: widget.padding,
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    return widget.placeholder ?? const SizedBox.shrink();
  }
}
