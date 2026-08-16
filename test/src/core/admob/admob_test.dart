import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdMobTestIds', () {
    test('provides valid non-empty test ad unit IDs', () {
      expect(AdMobTestIds.bannerAndroid, isNotEmpty);
      expect(AdMobTestIds.bannerIos, isNotEmpty);
      expect(AdMobTestIds.interstitialAndroid, isNotEmpty);
      expect(AdMobTestIds.interstitialIos, isNotEmpty);
      expect(AdMobTestIds.rewardedAndroid, isNotEmpty);
      expect(AdMobTestIds.rewardedIos, isNotEmpty);
      expect(AdMobTestIds.appOpenAndroid, isNotEmpty);
      expect(AdMobTestIds.appOpenIos, isNotEmpty);
      expect(AdMobTestIds.nativeAndroid, isNotEmpty);
      expect(AdMobTestIds.nativeIos, isNotEmpty);
    });
  });

  group('AdMobConfig', () {
    test('defaults to testing mode fallback when configured', () {
      const config = AdMobConfig(
        isTesting: true,
      );

      expect(config.bannerAdUnitId, equals(AdMobTestIds.banner));
      expect(config.interstitialAdUnitId, equals(AdMobTestIds.interstitial));
      expect(config.rewardedAdUnitId, equals(AdMobTestIds.rewarded));
      expect(config.appOpenAdUnitId, equals(AdMobTestIds.appOpen));
      expect(config.nativeAdUnitId, equals(AdMobTestIds.native));
    });

    test('custom ad unit IDs are configured and returned properly', () {
      const config = AdMobConfig(
        bannerAndroidId: 'custom_banner_android',
        interstitialAndroidId: 'custom_interstitial_android',
        rewardedAndroidId: 'custom_rewarded_android',
        appOpenAndroidId: 'custom_app_open_android',
        nativeAndroidId: 'custom_native_android',
      );

      expect(config.enabled, isTrue);
      expect(config.enableOfflineCustomAds, isTrue);
    });
  });

  group('CustomAdModel & CustomAdPool', () {
    test('registers and retrieves custom ads', () {
      final customAd1 = CustomAdModel(
        headerInfo: 'Recommended for you',
        appName: 'Hamro Maya App',
        appPackageName: 'com.princethakuri.hamromaya',
        appMessage: 'Best collection of Nepali Shayari & Quotes.',
        appDetails: 'Hamro Maya brings you the best collection of Nepali Shayari.',
        appIconPath: 'assets/icons/app_icon.png',
      );

      CustomAdPool.registerAds([customAd1]);
      expect(CustomAdPool.allAds.length, equals(1));

      final randomAd = CustomAdPool.getRandom();
      expect(randomAd.appName, equals('Hamro Maya App'));
      expect(randomAd.appPackageName, equals('com.princethakuri.hamromaya'));
    });

    test('CustomAdModelApps wrapper functions seamlessly', () {
      final apps = CustomAdModelApps();
      expect(apps.list, isNotEmpty);
      final random = apps.getRandom();
      expect(random.appName, isNotEmpty);
    });
  });

  group('AdMobService State', () {
    test('ad-free mode toggle updates state properly', () {
      expect(AdMobService.isAdFree, isFalse);
      AdMobService.setAdFree(true);
      expect(AdMobService.isAdFree, isTrue);
      AdMobService.setAdFree(false);
      expect(AdMobService.isAdFree, isFalse);
    });

    test('showInterstitial auto executes callback when ad-free is true', () {
      AdMobService.setAdFree(true);
      bool completed = false;

      AdMobService.showInterstitial(
        onCompleted: () {
          completed = true;
        },
      );

      expect(completed, isTrue);
      AdMobService.setAdFree(false);
    });
  });

  group('Smart Widgets distinct adId parameter validation', () {
    testWidgets('SmartBannerAdView accepts different adId per instance', (tester) async {
      const banner1 = SmartBannerAdView(adId: 'ca-app-pub-custom/banner-home');
      const banner2 = SmartBannerAdView(adId: 'ca-app-pub-custom/banner-details');

      expect(banner1.adId, equals('ca-app-pub-custom/banner-home'));
      expect(banner2.adId, equals('ca-app-pub-custom/banner-details'));
    });

    testWidgets('SmartNativeAdView accepts different adId and heights per instance', (tester) async {
      const native1 = SmartNativeAdView(adId: 'ca-app-pub-custom/native-feed', height: 355);
      const native2 = SmartNativeAdView(adId: 'ca-app-pub-custom/native-exit', height: 120);

      expect(native1.adId, equals('ca-app-pub-custom/native-feed'));
      expect(native1.height, equals(355));
      expect(native2.adId, equals('ca-app-pub-custom/native-exit'));
      expect(native2.height, equals(120));
    });
  });

  group('AdIcon Widget', () {
    testWidgets('renders AdIcon with badge and child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdIcon(
              child: Icon(Icons.star),
            ),
          ),
        ),
      );

      expect(find.text('Ad '), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
