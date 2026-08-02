import 'package:flutter/foundation.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Comprehensive AdMob service manager supporting all AdMob formats:
/// Interstitial, Rewarded, Rewarded Interstitial, and App Open ads.
///
/// Example usage:
/// ```dart
/// await AdMobService.initialize();
///
/// // Load and show interstitial ad
/// AdMobService.loadInterstitial(adUnitId: myInterstitialId, onAdLoaded: () {
///   AdMobService.showInterstitial();
/// });
///
/// // Load and show rewarded ad
/// AdMobService.loadRewarded(
///   adUnitId: myRewardedId,
///   onUserEarnedReward: (reward) {
///     print('User earned reward: ${reward.amount} ${reward.type}');
///   },
/// );
/// ```
class AdMobService {
  AdMobService._();

  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static RewardedInterstitialAd? _rewardedInterstitialAd;
  static AppOpenAd? _appOpenAd;

  /// Initializes Google Mobile Ads SDK with optional request configuration / test devices.
  static Future<InitializationStatus> initialize({
    List<String>? testDeviceIds,
  }) async {
    final status = await MobileAds.instance.initialize();
    if (testDeviceIds != null && testDeviceIds.isNotEmpty) {
      final configuration = RequestConfiguration(
        testDeviceIds: testDeviceIds,
      );
      await MobileAds.instance.updateRequestConfiguration(configuration);
    }
    FlutterLogger.info('Google Mobile Ads SDK initialized successfully', tag: 'ADMOB');
    return status;
  }

  // ===========================================================================
  // INTERSTITIAL ADS
  // ===========================================================================

  /// Loads an Interstitial Ad.
  static void loadInterstitial({
    required String adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          FlutterLogger.info('Interstitial Ad loaded successfully', tag: 'ADMOB');
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error('Failed to load Interstitial Ad: $error', tag: 'ADMOB');
          _interstitialAd = null;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Displays the preloaded Interstitial Ad if available.
  static void showInterstitial({
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_interstitialAd == null) {
      FlutterLogger.warning('Attempted to show Interstitial Ad before it was loaded', tag: 'ADMOB');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onAdFailedToShow?.call(error);
      },
    );

    _interstitialAd!.show();
  }

  // ===========================================================================
  // REWARDED ADS
  // ===========================================================================

  /// Loads a Rewarded Video Ad.
  static void loadRewarded({
    required String adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          FlutterLogger.info('Rewarded Ad loaded successfully', tag: 'ADMOB');
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error('Failed to load Rewarded Ad: $error', tag: 'ADMOB');
          _rewardedAd = null;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Displays the preloaded Rewarded Ad.
  static void showRewarded({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_rewardedAd == null) {
      FlutterLogger.warning('Attempted to show Rewarded Ad before it was loaded', tag: 'ADMOB');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        onAdFailedToShow?.call(error);
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onUserEarnedReward(reward);
      },
    );
  }

  // ===========================================================================
  // REWARDED INTERSTITIAL ADS
  // ===========================================================================

  /// Loads a Rewarded Interstitial Ad.
  static void loadRewardedInterstitial({
    required String adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) {
    RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          FlutterLogger.info('Rewarded Interstitial Ad loaded', tag: 'ADMOB');
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error('Failed to load Rewarded Interstitial: $error', tag: 'ADMOB');
          _rewardedInterstitialAd = null;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Displays the preloaded Rewarded Interstitial Ad.
  static void showRewardedInterstitial({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_rewardedInterstitialAd == null) {
      FlutterLogger.warning('Attempted to show Rewarded Interstitial before load', tag: 'ADMOB');
      return;
    }

    _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        onAdFailedToShow?.call(error);
      },
    );

    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) {
        onUserEarnedReward(reward);
      },
    );
  }

  // ===========================================================================
  // APP OPEN ADS
  // ===========================================================================

  /// Loads an App Open Ad.
  static void loadAppOpen({
    required String adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) {
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          FlutterLogger.info('App Open Ad loaded successfully', tag: 'ADMOB');
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error('Failed to load App Open Ad: $error', tag: 'ADMOB');
          _appOpenAd = null;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Displays the preloaded App Open Ad.
  static void showAppOpen({
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_appOpenAd == null) {
      FlutterLogger.warning('Attempted to show App Open Ad before load', tag: 'ADMOB');
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpenAd = null;
        onAdFailedToShow?.call(error);
      },
    );

    _appOpenAd!.show();
  }

  /// Clean up and dispose all loaded ad instances.
  static void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    _appOpenAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
    _rewardedInterstitialAd = null;
    _appOpenAd = null;
  }
}
