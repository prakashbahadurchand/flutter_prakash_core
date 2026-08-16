import 'package:flutter/material.dart';
import 'package:flutter_prakash/src/core/admob/admob_banner_widget.dart';
import 'package:flutter_prakash/src/core/admob/admob_service.dart';
import 'package:flutter_prakash/src/core/admob/custom_ad_model.dart';
import 'package:flutter_prakash/src/core/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Helper widget to easily load and display Adaptive Banner Ads dynamically calculated from context width.
///
/// Follows Google AdMob guidelines:
/// - Calculates anchored adaptive banner sizing dynamically.
/// - Keeps alive across list scrolls to prevent repeated request overhead and flickering.
/// - Falls back smoothly when offline.
class AdMobAdaptiveBannerWidget extends StatefulWidget {
  const AdMobAdaptiveBannerWidget({
    super.key,
    this.adUnitId,
    this.padding = EdgeInsets.zero,
    this.placeholder,
    this.customAd,
    this.enableOfflineCustomAd = true,
    this.keepAlive = true,
  });

  /// Specific Ad Unit ID for this adaptive banner. If omitted, [AdMobService.config.bannerAdUnitId] is used.
  final String? adUnitId;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Optional placeholder.
  final Widget? placeholder;

  /// Custom promotional ad to display when offline.
  final CustomAdModel? customAd;

  /// Whether to display developer custom fallback ad when offline.
  final bool enableOfflineCustomAd;

  /// Keep ad loaded when scrolled out of view in lists.
  final bool keepAlive;

  @override
  State<AdMobAdaptiveBannerWidget> createState() =>
      _AdMobAdaptiveBannerWidgetState();
}

class _AdMobAdaptiveBannerWidgetState extends State<AdMobAdaptiveBannerWidget>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  bool _isLoading = false;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdaptiveAd();
  }

  @override
  void didUpdateWidget(covariant AdMobAdaptiveBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId != widget.adUnitId) {
      _loadAdaptiveAd();
    }
  }

  Future<void> _loadAdaptiveAd() async {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) return;
    if (_isLoading || _isLoaded) return;

    _isLoading = true;
    final width = MediaQuery.of(context).size.width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);

    if (size == null) {
      _isLoading = false;
      return;
    }

    if (!mounted) return;
    setState(() {
      _adSize = size;
    });

    _bannerAd?.dispose();
    _bannerAd = null;

    final resolvedUnitId = (AdMobService.config.isTesting && widget.adUnitId == null)
        ? AdMobService.config.bannerAdUnitId
        : (widget.adUnitId ?? AdMobService.config.bannerAdUnitId);

    _bannerAd = BannerAd(
      adUnitId: resolvedUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          FlutterLogger.info('Adaptive Banner loaded successfully', tag: 'ADMOB');
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _isLoading = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          FlutterLogger.error('Adaptive Banner failed to load: $error', tag: 'ADMOB');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _isLoading = false;
              _bannerAd = null;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (AdMobService.isAdFree || !AdMobService.isEnabled) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _bannerAd != null && _adSize != null) {
      return Padding(
        padding: widget.padding,
        child: SizedBox(
          width: _adSize!.width.toDouble(),
          height: _adSize!.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    // Fallback to standard smart banner with custom offline promo if adaptive failed
    if (!_isLoading && _bannerAd == null && widget.enableOfflineCustomAd) {
      return AdMobBannerWidget(
        adUnitId: widget.adUnitId,
        padding: widget.padding,
        placeholder: widget.placeholder,
        customAd: widget.customAd,
        enableOfflineCustomAd: widget.enableOfflineCustomAd,
        keepAlive: widget.keepAlive,
      );
    }

    return widget.placeholder ?? const SizedBox.shrink();
  }
}
