import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_prakash_ads/flutter_prakash_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ads_state.dart';

@lazySingleton
class AdsCubit extends Cubit<AdsState> {
  AdsCubit({required this.adsService}) : super(const AdsState()) {
    _loadSavedCoins();
  }

  final AdsService adsService;
  static const String _keyEarnedCoins = 'user_earned_coins_balance';

  Future<void> _loadSavedCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCoins = prefs.getInt(_keyEarnedCoins) ?? 0;
    if (savedCoins > 0) {
      emit(state.copyWith(coins: savedCoins));
    }
  }

  /// 🔄 Preload all ad formats at once
  void loadAllAds() {
    emit(state.copyWith(statusMessage: 'Loading all ads in background...'));

    adsService.loadInterstitialAd(
      onLoaded: () => updateAdStatus('Interstitial Ad Ready'),
      onFailedToLoad: (error) =>
          updateAdStatus('Interstitial Failed: ${error.message}'),
    );

    adsService.loadRewardedAd(
      onLoaded: () => updateAdStatus('Rewarded Video Ready'),
      onFailedToLoad: (error) =>
          updateAdStatus('Rewarded Failed: ${error.message}'),
    );

    adsService.loadRewardedInterstitialAd(
      onLoaded: () => updateAdStatus('Rewarded Interstitial Ready'),
      onFailedToLoad: (error) =>
          updateAdStatus('Rewarded Interstitial Failed: ${error.message}'),
    );

    adsService.loadAppOpenAd(
      onLoaded: () => updateAdStatus('App Open Ad Ready'),
      onFailedToLoad: (error) =>
          updateAdStatus('App Open Failed: ${error.message}'),
    );
  }

  /// 🎬 1. Show Interstitial Ad (with built-in 30s interval throttling)
  void showInterstitialAd() {
    if (adsService.isInterstitialAdAvailable) {
      adsService.showInterstitialAd(
        onAdShowedFullScreenContent: () =>
            updateAdStatus('Interstitial Ad Displayed'),
        onAdDismissedFullScreenContent: () =>
            updateAdStatus('Interstitial Ad Dismissed'),
        onAdFailedToShowFullScreenContent: (error) =>
            updateAdStatus('Interstitial Failed to Show: ${error.message}'),
      );
    } else {
      emit(
        state.copyWith(
          snackBarMessage: 'Interstitial Ad not ready yet, loading...',
          isSuccessMessage: false,
        ),
      );
      adsService.loadInterstitialAd(
        onLoaded: () => updateAdStatus('Interstitial Ad Ready'),
        onFailedToLoad: (error) =>
            updateAdStatus('Interstitial Failed: ${error.message}'),
      );
    }
  }

  /// 🎁 2. Show Rewarded Video Ad
  void showRewardedAd() {
    if (adsService.isRewardedAdAvailable) {
      adsService.showRewardedAd(
        onUserEarnedReward: (ad, reward) {
          final amount = reward.amount.toInt() == 0
              ? 50
              : reward.amount.toInt();
          userEarnedReward(amount);
        },
        onAdShowedFullScreenContent: () =>
            updateAdStatus('Rewarded Video Displayed'),
        onAdDismissedFullScreenContent: () =>
            updateAdStatus('Rewarded Video Dismissed'),
        onAdFailedToShowFullScreenContent: (error) =>
            updateAdStatus('Rewarded Failed to Show: ${error.message}'),
      );
    } else {
      emit(
        state.copyWith(
          snackBarMessage: 'Rewarded Ad not ready yet, loading...',
          isSuccessMessage: false,
        ),
      );
      adsService.loadRewardedAd(
        onLoaded: () => updateAdStatus('Rewarded Video Ready'),
        onFailedToLoad: (error) =>
            updateAdStatus('Rewarded Failed: ${error.message}'),
      );
    }
  }

  /// 💎 3. Show Rewarded Interstitial Ad
  void showRewardedInterstitialAd() {
    if (adsService.isRewardedInterstitialAdAvailable) {
      adsService.showRewardedInterstitialAd(
        onUserEarnedReward: (ad, reward) {
          final amount = reward.amount.toInt() == 0
              ? 100
              : reward.amount.toInt();
          userEarnedReward(amount);
        },
        onAdShowedFullScreenContent: () =>
            updateAdStatus('Rewarded Interstitial Displayed'),
        onAdDismissedFullScreenContent: () =>
            updateAdStatus('Rewarded Interstitial Dismissed'),
        onAdFailedToShowFullScreenContent: (error) => updateAdStatus(
          'Rewarded Interstitial Failed to Show: ${error.message}',
        ),
      );
    } else {
      emit(
        state.copyWith(
          snackBarMessage: 'Rewarded Interstitial Ad not ready yet, loading...',
          isSuccessMessage: false,
        ),
      );
      adsService.loadRewardedInterstitialAd(
        onLoaded: () => updateAdStatus('Rewarded Interstitial Ready'),
        onFailedToLoad: (error) =>
            updateAdStatus('Rewarded Interstitial Failed: ${error.message}'),
      );
    }
  }

  /// 🚪 4. Show App Open Ad
  void showAppOpenAd() {
    if (adsService.isAppOpenAdAvailable) {
      adsService.showAppOpenAdIfAvailable(
        onAdShowedFullScreenContent: () =>
            updateAdStatus('App Open Ad Displayed'),
        onAdDismissedFullScreenContent: () =>
            updateAdStatus('App Open Ad Dismissed'),
        onAdFailedToShowFullScreenContent: (error) =>
            updateAdStatus('App Open Failed to Show: ${error.message}'),
      );
    } else {
      emit(
        state.copyWith(
          snackBarMessage: 'App Open Ad not ready yet, loading...',
          isSuccessMessage: false,
        ),
      );
      adsService.loadAppOpenAd(
        onLoaded: () => updateAdStatus('App Open Ad Ready'),
        onFailedToLoad: (error) =>
            updateAdStatus('App Open Failed: ${error.message}'),
      );
    }
  }

  /// 💰 Update user reward coins and persist to storage
  void userEarnedReward(int amount) {
    final updatedCoins = state.coins + amount;
    emit(
      state.copyWith(
        coins: updatedCoins,
        snackBarMessage: '🎉 Reward Granted: +$amount Coins!',
        isSuccessMessage: true,
      ),
    );
    _persistCoins(updatedCoins);
  }

  Future<void> _persistCoins(int total) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyEarnedCoins, total);
  }

  /// 📢 Update status message and ad readiness flags
  void updateAdStatus(String statusMessage) {
    emit(
      state.copyWith(
        statusMessage: statusMessage,
        isInterstitialLoaded: adsService.isInterstitialAdAvailable,
        isRewardedLoaded: adsService.isRewardedAdAvailable,
        isRewardedInterstitialLoaded:
            adsService.isRewardedInterstitialAdAvailable,
        isAppOpenLoaded: adsService.isAppOpenAdAvailable,
      ),
    );
  }

  @override
  Future<void> close() {
    adsService.dispose();
    return super.close();
  }
}
