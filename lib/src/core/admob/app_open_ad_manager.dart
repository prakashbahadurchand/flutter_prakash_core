import 'package:flutter/foundation.dart';
import 'package:flutter_prakash/src/core/admob/admob_service.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Utility class that manages loading, caching, and displaying App Open Ads with zero boilerplate.
class AppOpenAdManager {
  AppOpenAdManager({
    String? adUnitId,
    Duration? maxCacheDuration,
  })  : _adUnitId = adUnitId,
        maxCacheDuration = maxCacheDuration ?? const Duration(hours: 4);

  final String? _adUnitId;

  /// Maximum duration allowed between loading and showing the ad (default: 4 hours).
  final Duration maxCacheDuration;

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isLoadingAd = false;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable => _appOpenAd != null;

  /// Whether an App Open ad is currently visible on screen.
  bool get isShowingAd => _isShowingAd;

  /// Load an [AppOpenAd] if not already loaded or loading.
  void loadAd({String? adUnitId}) {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) return;
    if (_isLoadingAd || isAdAvailable) return;

    final resolvedUnitId =
        adUnitId ?? _adUnitId ?? AdMobService.config.appOpenAdUnitId;
    _isLoadingAd = true;

    AppOpenAd.load(
      adUnitId: resolvedUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          FlutterLogger.info('AppOpenAd loaded successfully', tag: 'ADMOB');
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          _isLoadingAd = false;
        },
        onAdFailedToLoad: (error) {
          FlutterLogger.error(
            'AppOpenAd failed to load: $error',
            tag: 'ADMOB',
          );
          _isLoadingAd = false;
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Shows the ad if available, cached, and not expired.
  void showAdIfAvailable({
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) {
      onAdDismissed?.call();
      return;
    }

    if (!isAdAvailable) {
      FlutterLogger.info(
        'AppOpenAd requested before ready. Triggering preload.',
        tag: 'ADMOB',
      );
      loadAd();
      onAdDismissed?.call();
      return;
    }

    if (_isShowingAd) {
      FlutterLogger.warning(
        'AppOpenAd skipped: Another ad is currently showing.',
        tag: 'ADMOB',
      );
      onAdDismissed?.call();
      return;
    }

    if (_appOpenLoadTime != null &&
        DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      FlutterLogger.warning(
        'AppOpenAd cache duration exceeded 4 hours. Discarding and reloading.',
        tag: 'ADMOB',
      );
      _appOpenAd?.dispose();
      _appOpenAd = null;
      loadAd();
      onAdDismissed?.call();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        FlutterLogger.info('AppOpenAd onAdShowedFullScreenContent', tag: 'ADMOB');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        FlutterLogger.error(
          'AppOpenAd onAdFailedToShowFullScreenContent: $error',
          tag: 'ADMOB',
        );
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        onAdFailedToShow?.call(error);
        loadAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        FlutterLogger.info(
          'AppOpenAd onAdDismissedFullScreenContent',
          tag: 'ADMOB',
        );
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        onAdDismissed?.call();
        loadAd();
      },
    );

    _appOpenAd!.show();
  }

  /// Disposes cached App Open ad instance.
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isLoadingAd = false;
    _isShowingAd = false;
  }
}
