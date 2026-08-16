import 'dart:math';
import 'package:flutter_prakash/src/core/admob/custom_ad_model.dart';

/// Registry and pool of developer custom ads used as offline fallbacks or direct cross-promotions.
class CustomAdPool {
  CustomAdPool._();

  static final List<CustomAdModel> _customAds = [];

  /// Global default fallback custom ad if pool is empty.
  static const CustomAdModel defaultFallbackAd = CustomAdModel(
    headerInfo: 'Recommended for you',
    appName: 'Discover More Apps',
    appPackageName: 'com.prakashbahadurchand',
    appMessage: 'Explore amazing utilities and apps developed for you.',
    appDetails:
        'Tap download to check out our complete catalog of mobile applications and tools.',
    appIconPath: '',
    isAssetImage: false,
  );

  /// Registers a list of custom promotional ads.
  static void registerAds(List<CustomAdModel> ads) {
    _customAds.clear();
    _customAds.addAll(ads);
  }

  /// Adds a single custom promotional ad.
  static void addAd(CustomAdModel ad) {
    _customAds.add(ad);
  }

  /// Returns all registered custom ads.
  static List<CustomAdModel> get allAds => List.unmodifiable(_customAds);

  /// Returns a random custom ad from the pool.
  static CustomAdModel getRandom() {
    if (_customAds.isEmpty) {
      return defaultFallbackAd;
    }
    return _customAds[Random().nextInt(_customAds.length)];
  }
}

/// Convenience alias matching user standard pattern.
class CustomAdModelApps {
  CustomAdModelApps({List<CustomAdModel>? ads}) {
    if (ads != null && ads.isNotEmpty) {
      CustomAdPool.registerAds(ads);
    }
  }

  List<CustomAdModel> get list => CustomAdPool.allAds;

  CustomAdModel getRandom() => CustomAdPool.getRandom();
}
