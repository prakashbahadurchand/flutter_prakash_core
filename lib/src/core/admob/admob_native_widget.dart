import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Native Ad widget wrapper to display customized native ads safely with loading states.
class AdMobNativeWidget extends StatefulWidget {
  const AdMobNativeWidget({
    required this.adUnitId,
    super.key,
    this.factoryId = 'listTile',
    this.height = 100,
    this.width = double.infinity,
    this.padding = EdgeInsets.zero,
    this.placeholder,
  });

  final String adUnitId;
  final String factoryId;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final Widget? placeholder;

  @override
  State<AdMobNativeWidget> createState() => _AdMobNativeWidgetState();
}

class _AdMobNativeWidgetState extends State<AdMobNativeWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      factoryId: widget.factoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
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
              _nativeAd = null;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _nativeAd != null) {
      return Padding(
        padding: widget.padding,
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: AdWidget(ad: _nativeAd!),
        ),
      );
    }

    return widget.placeholder ?? const SizedBox.shrink();
  }
}
