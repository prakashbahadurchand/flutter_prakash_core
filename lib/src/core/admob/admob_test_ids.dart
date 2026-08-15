import 'dart:io';

/// Helper utility providing official Google AdMob Test Ad Unit IDs for Android and iOS
/// across all supported AdMob formats (Banner, Interstitial, Rewarded, Rewarded Interstitial, App Open, Native).
class AdMobTestIds {
  AdMobTestIds._();

  // Official Test Ad Unit IDs from Google AdMob documentation

  // Banner
  static const String bannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String bannerIos = 'ca-app-pub-3940256099942544/2934735716';

  // Interstitial
  static const String interstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialIos =
      'ca-app-pub-3940256099942544/4411468910';

  // Rewarded
  static const String rewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String rewardedIos = 'ca-app-pub-3940256099942544/1712485313';

  // Rewarded Interstitial
  static const String rewardedInterstitialAndroid =
      'ca-app-pub-3940256099942544/5354046379';
  static const String rewardedInterstitialIos =
      'ca-app-pub-3940256099942544/6978759866';

  // App Open
  static const String appOpenAndroid = 'ca-app-pub-3940256099942544/9257395921';
  static const String appOpenIos = 'ca-app-pub-3940256099942544/5609710369';

  // Native Advanced
  static const String nativeAndroid = 'ca-app-pub-3940256099942544/2247696110';
  static const String nativeIos = 'ca-app-pub-3940256099942544/3986624511';

  /// Platform-aware test banner ID.
  static String get banner => Platform.isAndroid ? bannerAndroid : bannerIos;

  /// Platform-aware test interstitial ID.
  static String get interstitial =>
      Platform.isAndroid ? interstitialAndroid : interstitialIos;

  /// Platform-aware test rewarded ID.
  static String get rewarded =>
      Platform.isAndroid ? rewardedAndroid : rewardedIos;

  /// Platform-aware test rewarded interstitial ID.
  static String get rewardedInterstitial => Platform.isAndroid
      ? rewardedInterstitialAndroid
      : rewardedInterstitialIos;

  /// Platform-aware test app open ID.
  static String get appOpen => Platform.isAndroid ? appOpenAndroid : appOpenIos;

  /// Platform-aware test native ID.
  static String get native => Platform.isAndroid ? nativeAndroid : nativeIos;
}
