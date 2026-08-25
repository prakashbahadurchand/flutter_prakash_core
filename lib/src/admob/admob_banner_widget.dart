import 'package:flutter/material.dart';
import 'package:flutter_prakash/src/admob/admob_service.dart';
import 'package:flutter_prakash/src/admob/custom_ad_model.dart';
import 'package:flutter_prakash/src/admob/custom_ad_pool.dart';
import 'package:flutter_prakash/src/admob/smart_custom_ad_dialog.dart';
import 'package:flutter_prakash/src/loggers/flutter_logger.dart';
import 'package:flutter_prakash/src/widgets/toast_overlay.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Ultra-low boilerplate Smart Banner Ad Widget with Google AdMob & offline developer cross-promotion fallback.
///
/// Fully aligned with Google AdMob policies:
/// - Supports unique ad unit IDs per screen/widget.
/// - Keeps ad alive in scrollable lists to prevent rapid re-fetching and layout shift.
/// - Strictly avoids showing custom placeholders while online and during fill requests.
/// - Only renders custom promotional fallback when completely offline.
class AdMobBannerWidget extends StatefulWidget {
  const AdMobBannerWidget({
    super.key,
    this.adUnitId,
    this.adSize = AdSize.banner,
    this.padding = EdgeInsets.zero,
    this.placeholder,
    this.customAd,
    this.enableOfflineCustomAd = true,
    this.keepAlive = true,
  });

  /// Specific Ad Unit ID for this banner. If omitted, [AdMobService.config.bannerAdUnitId] is used.
  final String? adUnitId;

  /// AdMob banner size (default: [AdSize.banner]).
  final AdSize adSize;

  /// Outer padding around the banner.
  final EdgeInsetsGeometry padding;

  /// Optional placeholder widget.
  final Widget? placeholder;

  /// Custom promotional ad to display when offline (defaults to random from [CustomAdPool]).
  final CustomAdModel? customAd;

  /// Whether to display developer custom fallback ad when device is offline.
  final bool enableOfflineCustomAd;

  /// Keep ad loaded when scrolled out of view in lists (prevents reload jitter & AdMob policy flags).
  final bool keepAlive;

  @override
  State<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<AdMobBannerWidget>
    with AutomaticKeepAliveClientMixin {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isCustomAdClosed = false;
  bool _hasInternet = true;
  late final CustomAdModel _customAd;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    _customAd = widget.customAd ?? CustomAdPool.getRandom();
    _checkInternetAndLoad();
  }

  @override
  void didUpdateWidget(covariant AdMobBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.adSize != widget.adSize) {
      _loadBannerAd();
    }
  }

  Future<void> _checkInternetAndLoad() async {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) return;

    try {
      final hasInternet = await InternetConnection().hasInternetAccess;
      if (mounted) {
        setState(() {
          _hasInternet = hasInternet;
        });
      }
    } catch (_) {}

    _loadBannerAd();
  }

  void _loadBannerAd() {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) return;

    _bannerAd?.dispose();
    _bannerAd = null;

    final resolvedUnitId =
        (AdMobService.config.isTesting && widget.adUnitId == null)
        ? AdMobService.config.bannerAdUnitId
        : (widget.adUnitId ?? AdMobService.config.bannerAdUnitId);

    _bannerAd = BannerAd(
      adUnitId: resolvedUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          FlutterLogger.info(
            'BannerAd loaded: ${ad.responseInfo?.mediationAdapterClassName}',
            tag: 'ADMOB',
          );
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, err) async {
          FlutterLogger.error('BannerAd failed to load: $err', tag: 'ADMOB');
          ad.dispose();
          _bannerAd = null;

          bool hasInternet = true;
          try {
            hasInternet = await InternetConnection().hasInternetAccess;
          } catch (_) {}

          if (mounted) {
            setState(() {
              _isLoaded = false;
              _hasInternet = hasInternet;
            });
          }
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
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

    if (_bannerAd != null && _isLoaded) {
      return Padding(
        padding: widget.padding,
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    // Per AdMob policies and user requirement:
    // If device has internet connection, do NOT show custom fallback ad before/during AdMob loading or on fill requests.
    // Custom ad is only shown as an offline fallback when internet is unavailable and user hasn't closed it.
    if (!widget.enableOfflineCustomAd || _hasInternet || _isCustomAdClosed) {
      return widget.placeholder ?? const SizedBox.shrink();
    }

    return Padding(
      padding: widget.padding,
      child: GestureDetector(
        onTap: () {
          SmartCustomAdDialog.show(context, _customAd);
        },
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: _customAd.primaryColor, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: _customAd.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(3),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      _customAd.badgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: _customAd.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      _customAd.headerInfo,
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Toast.info('Ad placed by developer is closed.');
                      if (mounted) {
                        setState(() {
                          _isCustomAdClosed = true;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _customAd.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_sharp,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 6),
                  CustomAdIconWidget(
                    ad: _customAd,
                    width: 32,
                    height: 32,
                    borderRadius: 4,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: RichText(
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: '${_customAd.appName} ',
                        style: TextStyle(
                          fontSize: 13,
                          color: _customAd.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: _customAd.appDetails,
                            style: TextStyle(
                              fontSize: 12,
                              color: _customAd.primaryColor.withValues(
                                alpha: 0.85,
                              ),
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Convenience alias matching user's SmartBannerAdView class with explicit adId parameter support.
class SmartBannerAdView extends StatelessWidget {
  const SmartBannerAdView({
    required this.adId,
    super.key,
    this.adSize = AdSize.banner,
    this.padding = EdgeInsets.zero,
    this.customAd,
    this.enableOfflineCustomAd = true,
    this.keepAlive = true,
  });

  /// Specific Banner Ad Unit ID passed from the widget.
  final String adId;

  /// Ad size (default: [AdSize.banner]).
  final AdSize adSize;

  /// Padding.
  final EdgeInsetsGeometry padding;

  /// Optional custom ad model for offline fallback.
  final CustomAdModel? customAd;

  /// Whether offline fallback is enabled.
  final bool enableOfflineCustomAd;

  /// Whether to keep alive in scrollable lists.
  final bool keepAlive;

  @override
  Widget build(BuildContext context) {
    return AdMobBannerWidget(
      adUnitId: adId,
      adSize: adSize,
      padding: padding,
      customAd: customAd,
      enableOfflineCustomAd: enableOfflineCustomAd,
      keepAlive: keepAlive,
    );
  }
}
