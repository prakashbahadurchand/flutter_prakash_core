import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Preloads and displays full-screen interstitial ads.
///
/// Keeps a single loaded [InterstitialAd] alive and exposes a [show] method
/// that invokes [onDismissed] after the ad is closed.
class InterstitialAdHandler {
  InterstitialAd? _interstitialAd;

  /// Called whenever a fresh ad finishes loading.
  final void Function(Ad ad)? onLoaded;

  InterstitialAdHandler({this.onLoaded});

  /// Whether an ad is currently loaded and ready to show.
  bool get isLoaded => _interstitialAd != null;

  /// Preloads an interstitial ad for the given unit id.
  Future<void> loadAd(String adUnitId) async {
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          onLoaded?.call(ad);
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Shows the preloaded ad; [onDismissed] fires when it closes.
  void show({required VoidCallback onDismissed}) {
    final ad = _interstitialAd;
    if (ad == null) {
      onDismissed();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onDismissed();
      },
    );
    ad.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
