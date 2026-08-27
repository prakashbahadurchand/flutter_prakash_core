import 'package:flutter/foundation.dart';

@immutable
class AdsState {
  const AdsState({
    this.coins = 0,
    this.statusMessage = 'Initialized & Ready to test ads',
    this.isInterstitialLoaded = false,
    this.isRewardedLoaded = false,
    this.isRewardedInterstitialLoaded = false,
    this.isAppOpenLoaded = false,
    this.snackBarMessage,
    this.isSuccessMessage = true,
  });

  final int coins;
  final String statusMessage;
  final bool isInterstitialLoaded;
  final bool isRewardedLoaded;
  final bool isRewardedInterstitialLoaded;
  final bool isAppOpenLoaded;
  final String? snackBarMessage;
  final bool isSuccessMessage;

  AdsState copyWith({
    int? coins,
    String? statusMessage,
    bool? isInterstitialLoaded,
    bool? isRewardedLoaded,
    bool? isRewardedInterstitialLoaded,
    bool? isAppOpenLoaded,
    String? snackBarMessage,
    bool? isSuccessMessage,
  }) {
    return AdsState(
      coins: coins ?? this.coins,
      statusMessage: statusMessage ?? this.statusMessage,
      isInterstitialLoaded: isInterstitialLoaded ?? this.isInterstitialLoaded,
      isRewardedLoaded: isRewardedLoaded ?? this.isRewardedLoaded,
      isRewardedInterstitialLoaded:
          isRewardedInterstitialLoaded ?? this.isRewardedInterstitialLoaded,
      isAppOpenLoaded: isAppOpenLoaded ?? this.isAppOpenLoaded,
      snackBarMessage: snackBarMessage,
      isSuccessMessage: isSuccessMessage ?? this.isSuccessMessage,
    );
  }
}
