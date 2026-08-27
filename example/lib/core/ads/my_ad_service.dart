import 'package:flutter_prakash_ads/flutter_prakash_ads.dart';
import 'package:flutter_prakash_core_example/core/utils/console_logger.dart';

class MyAdsService {
  static Future<void> initFromMain() async {
    // 1. Setup enterprise offline custom promotion fallback ads (shown if no network/fill)
    ConsoleLogger.info(
      'Configuring offline fallback promotional ads...',
      tag: 'ADS-INIT',
    );
    AdsManager.setupCustomAds(const [
      CustomAdModel(
        id: 'custom_pro_promo',
        title: 'Upgrade to Pro Edition',
        description:
            'Unlock 100+ premium features, analytics, and an ad-free experience.',
        callToAction: 'Upgrade Now',
        advertiser: 'Ads Clean Architecture Inc.',
        rating: 4.9,
      ),
      CustomAdModel(
        id: 'custom_cloud_promo',
        title: 'Cloud Sync & Backup',
        description:
            'Secure your app data and preferences with instant real-time synchronization.',
        callToAction: 'Learn More',
        advertiser: 'Cloud Engine Tools',
        rating: 4.8,
      ),
    ]);

    // 2. Centralized Ad Event & Revenue Analytics Listener (Firebase / Adjust / AppsFlyer)
    AdsManager.onAdEvent((event) {
      if (event.isPaid) {
        ConsoleLogger.adRevenue(
          format: event.format.name,
          revenue: event.revenueValue ?? 0.0,
          micros: event.valueMicros ?? 0.0,
          currency: event.currencyCode ?? 'USD',
          precision: event.precision?.name ?? 'unknown',
          adUnitId: event.adUnitId,
        );
      } else if (event.isError) {
        ConsoleLogger.warning(
          '${event.format.name} ad failed (${event.type.name})',
          tag: 'AD-ERROR',
          error:
              event.adError?.message ??
              event.loadAdError?.message ??
              'Code ${event.adError?.code ?? event.loadAdError?.code}',
        );
      } else {
        ConsoleLogger.adLifecycle(
          format: event.format.name,
          event: event.type.name,
          adUnitId: event.adUnitId,
        );
      }
    });

    // 3. Request User Messaging Platform (UMP) Consent (GDPR/CPRA compliance)
    ConsoleLogger.info('Requesting UMP consent status...', tag: 'UMP');
    final consentResult = await AdsManager.requestConsent();
    ConsoleLogger.success(
      'Consent evaluated (canRequestAds: ${consentResult.canRequestAds})',
      tag: 'UMP',
    );

    // 4. Initialize Google Mobile Ads SDK & App Open Lifecycle if consent permits
    if (consentResult.canRequestAds) {
      ConsoleLogger.info('Initializing Google Mobile Ads SDK...', tag: 'ADMOB');
      await AdsManager.instance.initialize();
      await AdsManager.instance.initializeAppOpenAd();
      ConsoleLogger.success(
        'Google Mobile Ads SDK & App Open Initialized!',
        tag: 'ADMOB',
      );
    } else {
      ConsoleLogger.warning(
        'Ad requests disallowed by user consent settings.',
        tag: 'ADMOB',
      );
    }
  }
}
