import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Well-known Google test ad unit IDs used during development.
class AdMobTestAds {
  const AdMobTestAds._();

  static const String bannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String bannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const String interstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialIos =
      'ca-app-pub-3940256099942544/4411468910';
  static const String rewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String rewardedIos = 'ca-app-pub-3940256099942544/8670071747';
  static const String nativeAndroid = 'ca-app-pub-3940256099942544/3429830481';
  static const String nativeIos = 'ca-app-pub-3940256099942544/1234567890';
}

class AdMobService {
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }
}

class PrakashBannerAd extends StatefulWidget {
  final String adUnitId;
  final AdSize adSize;

  const PrakashBannerAd({
    super.key,
    required this.adUnitId,
    this.adSize = AdSize.banner,
  });

  @override
  State<PrakashBannerAd> createState() => _PrakashBannerAdState();
}

class _PrakashBannerAdState extends State<PrakashBannerAd> {
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
            setState(() => _isLoaded = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }
}
