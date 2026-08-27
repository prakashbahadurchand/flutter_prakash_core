import 'package:flutter/foundation.dart';
import 'package:flutter_prakash_core/src/admob/admob_config.dart';
import 'package:flutter_prakash_core/src/admob/admob_consent_manager.dart';
import 'package:flutter_prakash_core/src/admob/app_lifecycle_reactor.dart';
import 'package:flutter_prakash_core/src/admob/app_open_ad_manager.dart';
import 'package:flutter_prakash_core/src/admob/custom_ad_model.dart';
import 'package:flutter_prakash_core/src/admob/custom_ad_pool.dart';
import 'package:flutter_prakash_core/src/admob/interstitial_ad_manager.dart';
import 'package:flutter_prakash_core/src/admob/rewarded_ad_manager.dart';
import 'package:flutter_prakash_core/src/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Comprehensive Master AdMob & Monetization Service Engine.
///
/// Features:
/// - 1-Line initialization for App Open, Banner, Native, Interstitial, & Rewarded ads.
/// - Automatic app foreground / background lifecycle management for App Open ads.
/// - Frequency & interval capping for Interstitials.
/// - Offline custom cross-promotion ads fallback when internet is unavailable.
/// - Global instant Ad-Free switch for premium / pro subscribers.
class AdMobService {
  AdMobService._();

  static AdMobConfig _config = const AdMobConfig();
  static bool _isAdFree = false;
  static bool _isInitialized = false;

  static AppOpenAdManager? _appOpenAdManager;
  static AppLifecycleReactor? _appLifecycleReactor;

  // Direct low-level cached ad instances for backward-compatibility
  static InterstitialAd? _rawInterstitialAd;
  static RewardedAd? _rawRewardedAd;
  static RewardedInterstitialAd? _rawRewardedInterstitialAd;
  static AppOpenAd? _rawAppOpenAd;

  /// Returns current global AdMob configuration.
  static AdMobConfig get config => _config;

  /// Whether ads are globally enabled in configuration.
  static bool get isEnabled => _config.enabled;

  /// Whether the user is in ad-free (premium/pro) mode.
  static bool get isAdFree => _isAdFree;

  /// Whether Mobile Ads SDK is fully initialized.
  static bool get isInitialized => _isInitialized;

  /// Master App Open Ad Manager instance.
  static AppOpenAdManager get appOpenAdManager =>
      _appOpenAdManager ??= AppOpenAdManager(
        adUnitId: _config.appOpenAdUnitId,
        maxCacheDuration: _config.appOpenMaxCacheDuration,
      );

  /// Master App Lifecycle Reactor instance.
  static AppLifecycleReactor get appLifecycleReactor => _appLifecycleReactor ??=
      AppLifecycleReactor(appOpenAdManager: appOpenAdManager);

  /// Sets global ad-free state (e.g. when user purchases a premium ad-free plan).
  ///
  /// Instantly disables all banners, native ads, app open ads, and interstitials app-wide.
  static void setAdFree(bool adFree) {
    _isAdFree = adFree;
    FlutterLogger.info('AdMobService isAdFree set to: $adFree', tag: 'ADMOB');
    if (adFree) {
      dispose();
    }
  }

  /// Registers or replaces custom cross-promotion ads in the pool.
  static void setCustomAds(List<CustomAdModel> ads) {
    CustomAdPool.registerAds(ads);
  }

  /// Initializes Google Mobile Ads SDK, configures test devices, GDPR consent, and optional App Open auto-show.
  ///
  /// Example:
  /// ```dart
  /// await AdMobService.initialize(
  ///   config: AdMobConfig(
  ///     bannerAndroidId: '...',
  ///     interstitialAndroidId: '...',
  ///     appOpenAndroidId: '...',
  ///     isTesting: kDebugMode,
  ///   ),
  ///   autoShowAppOpen: true,
  /// );
  /// ```
  static Future<InitializationStatus> initialize({
    AdMobConfig? config,
    bool autoShowAppOpen = false,
    bool requestConsent = false,
    List<String>? testDeviceIds,
    void Function(FormError? error)? onConsentComplete,
  }) async {
    if (config != null) {
      _config = config;
      if (config.customAds != null && config.customAds!.isNotEmpty) {
        CustomAdPool.registerAds(config.customAds!);
      }
    }

    _appOpenAdManager = AppOpenAdManager(
      adUnitId: _config.appOpenAdUnitId,
      maxCacheDuration: _config.appOpenMaxCacheDuration,
    );
    _appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: appOpenAdManager,
    );

    final status = await MobileAds.instance.initialize();
    _isInitialized = true;

    final devices = testDeviceIds ?? _config.testDeviceIds;
    if (devices != null && devices.isNotEmpty) {
      final configuration = RequestConfiguration(testDeviceIds: devices);
      await MobileAds.instance.updateRequestConfiguration(configuration);
    }

    FlutterLogger.info(
      'Google Mobile Ads SDK initialized successfully',
      tag: 'ADMOB',
    );

    if (requestConsent) {
      await AdMobConsentManager.requestConsent(
        testDeviceIds: devices,
        onConsentComplete: (error) {
          onConsentComplete?.call(error);
          if (autoShowAppOpen && _config.enabled && !_isAdFree) {
            _setupAppOpenAds();
          }
        },
      );
    } else if (autoShowAppOpen && _config.enabled && !_isAdFree) {
      _setupAppOpenAds();
    }

    return status;
  }

  static void _setupAppOpenAds() {
    appOpenAdManager.loadAd();
    appLifecycleReactor.listenToAppStateChanges();
  }

  /// Preloads Interstitial, Rewarded, and App Open ads in the background.
  static void preloadAll() {
    if (_isAdFree || !_config.enabled) return;
    preloadInterstitial();
    preloadRewarded();
    preloadAppOpen();
  }

  /// Preloads an Interstitial Ad in the background.
  static void preloadInterstitial({String? adUnitId}) {
    InterstitialAdManager.loadAd(adUnitId: adUnitId);
  }

  /// Preloads a Rewarded Ad in the background.
  static void preloadRewarded({String? adUnitId}) {
    RewardedAdManager.loadAd(adUnitId: adUnitId);
  }

  /// Preloads an App Open Ad in the background.
  static void preloadAppOpen({String? adUnitId}) {
    appOpenAdManager.loadAd(adUnitId: adUnitId);
  }

  // ===========================================================================
  // ULTRA LOW-BOILERPLATE SMART METHODS
  // ===========================================================================

  /// Shows an Interstitial Ad with auto frequency/interval capping and guaranteed [onCompleted] callback.
  static void showInterstitial({
    VoidCallback? onCompleted,
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
    String? adUnitId,
    bool force = false,
  }) {
    // If user provided onCompleted, use the high-level smart manager
    if (onCompleted != null || force) {
      InterstitialAdManager.showAuto(
        onCompleted: onCompleted,
        adUnitId: adUnitId,
        force: force,
      );
      return;
    }

    // Direct / legacy show
    if (_rawInterstitialAd != null) {
      _rawInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rawInterstitialAd = null;
          onAdDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rawInterstitialAd = null;
          onAdFailedToShow?.call(error);
        },
      );
      _rawInterstitialAd!.show();
    } else {
      InterstitialAdManager.showAd(
        onAdDismissed: onAdDismissed,
        onAdFailedToShow: onAdFailedToShow,
      );
    }
  }

  /// Shows a Rewarded Video Ad.
  static void showRewarded({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_rawRewardedAd != null) {
      _rawRewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rawRewardedAd = null;
          onAdDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rawRewardedAd = null;
          onAdFailedToShow?.call(error);
        },
      );
      _rawRewardedAd!.show(
        onUserEarnedReward: (ad, reward) => onUserEarnedReward(reward),
      );
    } else {
      RewardedAdManager.showAd(
        onUserEarnedReward: onUserEarnedReward,
        onAdDismissed: onAdDismissed,
        onAdFailedToShow: onAdFailedToShow,
      );
    }
  }

  /// Shows an App Open Ad if available.
  static void showAppOpen({
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_rawAppOpenAd != null) {
      _rawAppOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rawAppOpenAd = null;
          onAdDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rawAppOpenAd = null;
          onAdFailedToShow?.call(error);
        },
      );
      _rawAppOpenAd!.show();
    } else {
      appOpenAdManager.showAdIfAvailable(
        onAdDismissed: onAdDismissed,
        onAdFailedToShow: onAdFailedToShow,
      );
    }
  }

  // ===========================================================================
  // GRANULAR / BACKWARD-COMPATIBILITY METHODS
  // ===========================================================================

  /// Loads an Interstitial Ad manually.
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
          _rawInterstitialAd = ad;
          FlutterLogger.info(
            'Interstitial Ad loaded successfully',
            tag: 'ADMOB',
          );
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error(
            'Failed to load Interstitial: $error',
            tag: 'ADMOB',
          );
          _rawInterstitialAd = null;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Loads a Rewarded Ad manually.
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
          _rawRewardedAd = ad;
          FlutterLogger.info('Rewarded Ad loaded successfully', tag: 'ADMOB');
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error('Failed to load Rewarded: $error', tag: 'ADMOB');
          _rawRewardedAd = null;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Loads a Rewarded Interstitial Ad manually.
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
          _rawRewardedInterstitialAd = ad;
          FlutterLogger.info('Rewarded Interstitial Ad loaded', tag: 'ADMOB');
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error(
            'Failed to load Rewarded Interstitial: $error',
            tag: 'ADMOB',
          );
          _rawRewardedInterstitialAd = null;
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
    if (_rawRewardedInterstitialAd == null) {
      FlutterLogger.warning(
        'Attempted to show Rewarded Interstitial before load',
        tag: 'ADMOB',
      );
      return;
    }

    _rawRewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _rawRewardedInterstitialAd = null;
            onAdDismissed?.call();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _rawRewardedInterstitialAd = null;
            onAdFailedToShow?.call(error);
          },
        );

    _rawRewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) => onUserEarnedReward(reward),
    );
  }

  /// Loads an App Open Ad manually.
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
          _rawAppOpenAd = ad;
          FlutterLogger.info('App Open Ad loaded successfully', tag: 'ADMOB');
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error(
            'Failed to load App Open Ad: $error',
            tag: 'ADMOB',
          );
          _rawAppOpenAd = null;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Clean up and dispose all loaded ad instances.
  static void dispose() {
    _rawInterstitialAd?.dispose();
    _rawRewardedAd?.dispose();
    _rawRewardedInterstitialAd?.dispose();
    _rawAppOpenAd?.dispose();
    _rawInterstitialAd = null;
    _rawRewardedAd = null;
    _rawRewardedInterstitialAd = null;
    _rawAppOpenAd = null;
    InterstitialAdManager.dispose();
    RewardedAdManager.dispose();
    _appOpenAdManager?.dispose();
    _appLifecycleReactor?.dispose();
    _isInitialized = false;
  }
}
