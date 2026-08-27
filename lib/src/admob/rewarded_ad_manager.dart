import 'package:flutter/foundation.dart';
import 'package:flutter_prakash_core/src/admob/admob_service.dart';
import 'package:flutter_prakash_core/src/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Smart Rewarded Ad manager supporting automatic preloading, reward verification, and 1-line display.
class RewardedAdManager {
  RewardedAdManager._();

  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;

  /// Whether a rewarded ad is preloaded and ready to show.
  static bool get isAdLoaded => _rewardedAd != null;

  /// Loads a Rewarded Video Ad into cache.
  static void loadAd({
    String? adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) return;
    if (_isLoading || _rewardedAd != null) return;

    _isLoading = true;
    final resolvedId = adUnitId ?? AdMobService.config.rewardedAdUnitId;

    RewardedAd.load(
      adUnitId: resolvedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
          FlutterLogger.info(
            'Rewarded Ad loaded: ${ad.responseInfo?.mediationAdapterClassName}',
            tag: 'ADMOB',
          );
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isLoading = false;
          FlutterLogger.error(
            'Failed to load Rewarded Ad: $error',
            tag: 'ADMOB',
          );
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Displays the preloaded Rewarded Ad.
  static void showAd({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_rewardedAd == null) {
      FlutterLogger.warning(
        'Attempted to show Rewarded Ad before loaded. Preloading now.',
        tag: 'ADMOB',
      );
      loadAd();
      onAdFailedToShow?.call(
        AdError(0, 'Rewarded ad not ready yet', 'admob_service'),
      );
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        onAdDismissed?.call();
        // Automatically preload the next rewarded ad
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        FlutterLogger.error('Failed to show Rewarded Ad: $error', tag: 'ADMOB');
        ad.dispose();
        _rewardedAd = null;
        onAdFailedToShow?.call(error);
        loadAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        FlutterLogger.info(
          'User earned reward: ${reward.amount} ${reward.type}',
          tag: 'ADMOB',
        );
        onUserEarnedReward(reward);
      },
    );
  }

  /// Ultra-low boilerplate method to show rewarded video with safe fallback.
  static void showAuto({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onDismissed,
    void Function(AdError error)? onFailed,
    String? adUnitId,
  }) {
    if (!isAdLoaded) {
      loadAd(adUnitId: adUnitId);
      onFailed?.call(
        AdError(
          0,
          'Rewarded ad is still loading. Please try again in a moment.',
          'admob_service',
        ),
      );
      return;
    }

    showAd(
      onUserEarnedReward: onUserEarnedReward,
      onAdDismissed: onDismissed,
      onAdFailedToShow: onFailed,
    );
  }

  /// Clean up and dispose loaded instance.
  static void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoading = false;
  }
}

/// Convenience alias matching user's SmartRewardedAdManager class.
class SmartRewardedAdManager {
  static void loadAd({
    String? adUnitId,
    VoidCallback? onAdLoaded,
    void Function(LoadAdError error)? onAdFailedToLoad,
  }) => RewardedAdManager.loadAd(
    adUnitId: adUnitId,
    onAdLoaded: onAdLoaded,
    onAdFailedToLoad: onAdFailedToLoad,
  );

  static void showAd({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) => RewardedAdManager.showAd(
    onUserEarnedReward: onUserEarnedReward,
    onAdDismissed: onAdDismissed,
    onAdFailedToShow: onAdFailedToShow,
  );

  static void showAuto({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onDismissed,
    void Function(AdError error)? onFailed,
    String? adUnitId,
  }) => RewardedAdManager.showAuto(
    onUserEarnedReward: onUserEarnedReward,
    onDismissed: onDismissed,
    onFailed: onFailed,
    adUnitId: adUnitId,
  );
}
