import 'package:flutter_prakash_ads/flutter_prakash_ads.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';

abstract final class AppAdsHelper {
  /// Initializes Mobile Ads and preloads app open ads
  static Future<void> initializeAds() async {
    try {
      final consentResult = await AdManager.requestConsent();
      if (consentResult.canRequestAds) {
        await AdManager.instance.initialize();
        await AdManager.instance.initializeAppOpenAd();
        logInfo('flutter_prakash_ads initialized successfully', tag: 'ADS');
      }
    } catch (e, st) {
      logWarn('Failed to initialize flutter_prakash_ads: $e\n$st', tag: 'ADS');
    }
  }
}
