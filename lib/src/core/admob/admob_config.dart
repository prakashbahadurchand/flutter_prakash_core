import 'dart:io';
import 'package:flutter_prakash/src/core/admob/admob_test_ids.dart';
import 'package:flutter_prakash/src/core/admob/custom_ad_model.dart';

/// Centralized configuration for Google AdMob monetization & custom cross-promotion ads.
class AdMobConfig {
  const AdMobConfig({
    this.enabled = true,
    this.isTesting = false,
    this.testDeviceIds,
    this.bannerAndroidId,
    this.bannerIosId,
    this.interstitialAndroidId,
    this.interstitialIosId,
    this.rewardedAndroidId,
    this.rewardedIosId,
    this.rewardedInterstitialAndroidId,
    this.rewardedInterstitialIosId,
    this.appOpenAndroidId,
    this.appOpenIosId,
    this.nativeAndroidId,
    this.nativeIosId,
    this.enableOfflineCustomAds = true,
    this.customAds,
    this.interstitialMinInterval = const Duration(seconds: 45),
    this.interstitialActionInterval = 1,
    this.appOpenMaxCacheDuration = const Duration(hours: 4),
    this.appOpenThrottleDuration = const Duration(seconds: 30),
  });

  /// Master switch enabling or disabling all AdMob features.
  final bool enabled;

  /// When true, official Google AdMob test IDs are used instead of production IDs.
  final bool isTesting;

  /// List of test device IDs (obtained from logcat / console during development).
  final List<String>? testDeviceIds;

  // Banner IDs
  final String? bannerAndroidId;
  final String? bannerIosId;

  // Interstitial IDs
  final String? interstitialAndroidId;
  final String? interstitialIosId;

  // Rewarded Video IDs
  final String? rewardedAndroidId;
  final String? rewardedIosId;

  // Rewarded Interstitial IDs
  final String? rewardedInterstitialAndroidId;
  final String? rewardedInterstitialIosId;

  // App Open IDs
  final String? appOpenAndroidId;
  final String? appOpenIosId;

  // Native IDs
  final String? nativeAndroidId;
  final String? nativeIosId;

  /// Whether to display developer custom fallback ads when offline.
  final bool enableOfflineCustomAds;

  /// List of custom promotional ads.
  final List<CustomAdModel>? customAds;

  /// Minimum time interval required between showing two consecutive interstitials.
  final Duration interstitialMinInterval;

  /// Number of user action triggers before an interstitial is displayed (e.g. show every N actions).
  final int interstitialActionInterval;

  /// Maximum cache lifetime for preloaded App Open ads before discarding (default: 4 hours).
  final Duration appOpenMaxCacheDuration;

  /// Minimum delay after app launch or previous ad before showing another App Open ad.
  final Duration appOpenThrottleDuration;

  // ===========================================================================
  // RESOLVED AD UNIT IDS (Respects platform and isTesting flag)
  // ===========================================================================

  /// Resolved Banner Ad Unit ID.
  String get bannerAdUnitId {
    if (isTesting || (!Platform.isAndroid && !Platform.isIOS)) {
      return AdMobTestIds.banner;
    }
    if (Platform.isAndroid) {
      return bannerAndroidId ?? AdMobTestIds.bannerAndroid;
    }
    return bannerIosId ?? AdMobTestIds.bannerIos;
  }

  /// Resolved Interstitial Ad Unit ID.
  String get interstitialAdUnitId {
    if (isTesting || (!Platform.isAndroid && !Platform.isIOS)) {
      return AdMobTestIds.interstitial;
    }
    if (Platform.isAndroid) {
      return interstitialAndroidId ?? AdMobTestIds.interstitialAndroid;
    }
    return interstitialIosId ?? AdMobTestIds.interstitialIos;
  }

  /// Resolved Rewarded Ad Unit ID.
  String get rewardedAdUnitId {
    if (isTesting || (!Platform.isAndroid && !Platform.isIOS)) {
      return AdMobTestIds.rewarded;
    }
    if (Platform.isAndroid) {
      return rewardedAndroidId ?? AdMobTestIds.rewardedAndroid;
    }
    return rewardedIosId ?? AdMobTestIds.rewardedIos;
  }

  /// Resolved Rewarded Interstitial Ad Unit ID.
  String get rewardedInterstitialAdUnitId {
    if (isTesting || (!Platform.isAndroid && !Platform.isIOS)) {
      return AdMobTestIds.rewardedInterstitial;
    }
    if (Platform.isAndroid) {
      return rewardedInterstitialAndroidId ??
          AdMobTestIds.rewardedInterstitialAndroid;
    }
    return rewardedInterstitialIosId ?? AdMobTestIds.rewardedInterstitialIos;
  }

  /// Resolved App Open Ad Unit ID.
  String get appOpenAdUnitId {
    if (isTesting || (!Platform.isAndroid && !Platform.isIOS)) {
      return AdMobTestIds.appOpen;
    }
    if (Platform.isAndroid) {
      return appOpenAndroidId ?? AdMobTestIds.appOpenAndroid;
    }
    return appOpenIosId ?? AdMobTestIds.appOpenIos;
  }

  /// Resolved Native Ad Unit ID.
  String get nativeAdUnitId {
    if (isTesting || (!Platform.isAndroid && !Platform.isIOS)) {
      return AdMobTestIds.native;
    }
    if (Platform.isAndroid) {
      return nativeAndroidId ?? AdMobTestIds.nativeAndroid;
    }
    return nativeIosId ?? AdMobTestIds.nativeIos;
  }
}
