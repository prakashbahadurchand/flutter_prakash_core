import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Preloads and displays rewarded video ads.
///
/// Callers can either pass an [onRewardedEarned] callback at construction time
/// or await the reward returned by [show].
class RewardedAdHandler {
  RewardedAd? _rewardedAd;

  /// Fired when the user earns a reward.
  final void Function(RewardItem reward)? onRewardedEarned;

  /// Fired whenever an ad finishes loading (e.g. to enable a play button).
  final void Function()? onAdLoaded;

  RewardedAdHandler({this.onRewardedEarned, this.onAdLoaded});

  /// Whether a reward ad is currently loaded and ready to show.
  bool get isLoaded => _rewardedAd != null;

  /// Preloads a rewarded ad for the given unit id.
  Future<void> loadAd(String adUnitId) async {
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Shows the loaded rewarded ad. Returns the earned [RewardItem] when the
  /// user completes the action, or `null` if no ad was loaded.
  Future<RewardItem?> show() async {
    final ad = _rewardedAd;
    if (ad == null) return null;

    final completer = Completer<RewardItem?>();
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        completer.complete(null);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        completer.complete(null);
      },
    );
    ad.show(
      onUserEarnedReward: (ad, RewardItem reward) {
        onRewardedEarned?.call(reward);
        completer.complete(reward);
      },
    );
    return completer.future;
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
