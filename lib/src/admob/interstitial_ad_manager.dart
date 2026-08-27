import 'package:flutter/foundation.dart';
import 'package:flutter_prakash_core/src/admob/admob_service.dart';
import 'package:flutter_prakash_core/src/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Smart Interstitial Ad manager supporting background preloading, frequency capping, and 1-line display.
class InterstitialAdManager {
  InterstitialAdManager._();

  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;
  static DateTime? _lastShownTime;
  static int _actionCounter = 0;

  /// Whether an interstitial ad is preloaded and ready to show.
  static bool get isAdLoaded => _interstitialAd != null;

  /// Loads an Interstitial Ad into cache.
  static void loadAd({
    String? adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) return;
    if (_isLoading || _interstitialAd != null) return;

    _isLoading = true;
    final resolvedId = adUnitId ?? AdMobService.config.interstitialAdUnitId;

    InterstitialAd.load(
      adUnitId: resolvedId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          FlutterLogger.info(
            'Interstitial Ad loaded: ${ad.responseInfo?.mediationAdapterClassName}',
            tag: 'ADMOB',
          );
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isLoading = false;
          FlutterLogger.error(
            'Failed to load Interstitial Ad: $error',
            tag: 'ADMOB',
          );
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Displays the preloaded Interstitial Ad.
  static void showAd({
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) {
      onAdDismissed?.call();
      return;
    }

    if (_interstitialAd == null) {
      FlutterLogger.warning(
        'Attempted to show Interstitial Ad before loaded. Preloading now.',
        tag: 'ADMOB',
      );
      loadAd();
      onAdDismissed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _lastShownTime = DateTime.now();
        onAdDismissed?.call();
        // Automatically preload the next ad
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        FlutterLogger.error(
          'Failed to show Interstitial Ad: $error',
          tag: 'ADMOB',
        );
        ad.dispose();
        _interstitialAd = null;
        onAdFailedToShow?.call(error);
        loadAd();
      },
    );

    _interstitialAd!.show();
  }

  /// Ultra-low boilerplate method to show an interstitial ad with auto-capping and guaranteed completion callback.
  ///
  /// [onCompleted] is unconditionally called whether the ad was shown, skipped due to frequency capping,
  /// or failed to load, ensuring that navigation/gameplay continues without getting stuck.
  static void showAuto({
    VoidCallback? onCompleted,
    String? adUnitId,
    bool force = false,
  }) {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) {
      onCompleted?.call();
      return;
    }

    _actionCounter++;
    final config = AdMobService.config;

    // Check action interval capping
    if (!force &&
        config.interstitialActionInterval > 1 &&
        (_actionCounter % config.interstitialActionInterval != 0)) {
      onCompleted?.call();
      return;
    }

    // Check time interval capping
    if (!force && _lastShownTime != null) {
      final elapsed = DateTime.now().difference(_lastShownTime!);
      if (elapsed < config.interstitialMinInterval) {
        onCompleted?.call();
        return;
      }
    }

    if (!isAdLoaded) {
      loadAd(adUnitId: adUnitId);
      onCompleted?.call();
      return;
    }

    showAd(
      onAdDismissed: onCompleted,
      onAdFailedToShow: (_) => onCompleted?.call(),
    );
  }

  /// Clean up and dispose loaded instance.
  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoading = false;
  }
}

/// Convenience alias matching user's SmartInterstitialAdManager class.
class SmartInterstitialAdManager {
  static void loadAd({
    String? adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) => InterstitialAdManager.loadAd(
    adUnitId: adUnitId,
    onAdLoaded: onAdLoaded,
    onAdFailedToLoad: onAdFailedToLoad,
  );

  static void showAd({
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) => InterstitialAdManager.showAd(
    onAdDismissed: onAdDismissed,
    onAdFailedToShow: onAdFailedToShow,
  );

  static void showAuto({
    VoidCallback? onCompleted,
    String? adUnitId,
    bool force = false,
  }) => InterstitialAdManager.showAuto(
    onCompleted: onCompleted,
    adUnitId: adUnitId,
    force: force,
  );
}
