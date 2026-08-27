import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admob/admob_service.dart';
import 'package:flutter_prakash_core/src/admob/custom_ad_model.dart';
import 'package:flutter_prakash_core/src/admob/custom_ad_pool.dart';
import 'package:flutter_prakash_core/src/admob/smart_custom_ad_dialog.dart';
import 'package:flutter_prakash_core/src/loggers/flutter_logger.dart';
import 'package:flutter_prakash_core/src/widgets/toast_overlay.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Ultra-low boilerplate Native Ad widget with NativeTemplateStyle and offline cross-promotion fallback.
///
/// Fully aligned with Google AdMob policies:
/// - Supports passing distinct ad unit IDs per screen/widget.
/// - Keeps native ads alive in scrollable lists to prevent repeated unneeded ad impressions and reload flicker.
/// - Uses standard Flutter Native Templates (no native Android/iOS factory code needed).
/// - Shows developer promotional card strictly when completely offline.
class AdMobNativeWidget extends StatefulWidget {
  const AdMobNativeWidget({
    super.key,
    this.adUnitId,
    this.factoryId,
    this.templateType = TemplateType.medium,
    this.templateStyle,
    this.height = 355,
    this.width = double.infinity,
    this.padding = EdgeInsets.zero,
    this.placeholder,
    this.customAd,
    this.enableOfflineCustomAd = true,
    this.keepAlive = true,
  });

  /// Specific Ad Unit ID for this native ad. If omitted, `AdMobService.config.nativeAdUnitId` is used.
  final String? adUnitId;

  /// Optional native platform XML/XIB factory identifier (if custom platform layouts are used).
  final String? factoryId;

  /// Flutter Native Template type ([TemplateType.small] or [TemplateType.medium]).
  final TemplateType templateType;

  /// Optional custom styling for Native Template.
  final NativeTemplateStyle? templateStyle;

  /// Height of the native ad container (default: 355 for medium template, ~90 for small).
  final double height;

  /// Width of the native ad container (default: [double.infinity]).
  final double width;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Optional placeholder shown while loading.
  final Widget? placeholder;

  /// Custom promotional ad to display when offline.
  final CustomAdModel? customAd;

  /// Whether to display developer custom fallback ad when offline.
  final bool enableOfflineCustomAd;

  /// Keep ad loaded when scrolled out of view in lists (prevents reload jitter & AdMob policy flags).
  final bool keepAlive;

  @override
  State<AdMobNativeWidget> createState() => _AdMobNativeWidgetState();
}

class _AdMobNativeWidgetState extends State<AdMobNativeWidget>
    with AutomaticKeepAliveClientMixin {
  NativeAd? _nativeAd;
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
  void didUpdateWidget(covariant AdMobNativeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.factoryId != widget.factoryId ||
        oldWidget.templateType != widget.templateType) {
      _loadNativeAd();
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

    _loadNativeAd();
  }

  void _loadNativeAd() {
    if (AdMobService.isAdFree || !AdMobService.isEnabled) return;

    _nativeAd?.dispose();
    _nativeAd = null;

    final resolvedUnitId =
        (AdMobService.config.isTesting && widget.adUnitId == null)
        ? AdMobService.config.nativeAdUnitId
        : (widget.adUnitId ?? AdMobService.config.nativeAdUnitId);

    final defaultTemplateStyle =
        widget.templateStyle ??
        NativeTemplateStyle(
          templateType: widget.templateType,
          mainBackgroundColor: const Color(0xfffffbed),
          callToActionTextStyle: NativeTemplateTextStyle(
            textColor: Colors.white,
            style: NativeTemplateFontStyle.monospace,
            size: 16.0,
          ),
          primaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.black,
            style: NativeTemplateFontStyle.bold,
            size: 16.0,
          ),
          secondaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.black87,
            style: NativeTemplateFontStyle.italic,
            size: 14.0,
          ),
          tertiaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.black54,
            style: NativeTemplateFontStyle.normal,
            size: 14.0,
          ),
        );

    _nativeAd = NativeAd(
      adUnitId: resolvedUnitId,
      factoryId: widget.factoryId,
      nativeTemplateStyle: widget.factoryId == null
          ? defaultTemplateStyle
          : null,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          FlutterLogger.info('NativeAd loaded successfully', tag: 'ADMOB');
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) async {
          FlutterLogger.error('NativeAd failed to load: $error', tag: 'ADMOB');
          ad.dispose();
          _nativeAd = null;

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
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (AdMobService.isAdFree || !AdMobService.isEnabled) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _nativeAd != null) {
      return Padding(
        padding: widget.padding,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.amber, width: 1),
          ),
          child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: AdWidget(ad: _nativeAd!),
          ),
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
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _customAd.primaryColor, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: _customAd.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7),
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
                      style: const TextStyle(fontSize: 12, color: Colors.white),
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
                          topRight: Radius.circular(7),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_sharp,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomAdIconWidget(
                ad: _customAd,
                width: 64,
                height: 64,
                borderRadius: 8,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _customAd.appName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _customAd.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _customAd.appMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _customAd.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  _customAd.appDetails,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _customAd.openStore();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _customAd.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _customAd.installButtonText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Convenience alias matching user's SmartNativeAdView class with explicit adId parameter support.
class SmartNativeAdView extends StatelessWidget {
  const SmartNativeAdView({
    required this.adId,
    super.key,
    this.height = 355,
    this.templateType = TemplateType.medium,
    this.templateStyle,
    this.padding = EdgeInsets.zero,
    this.customAd,
    this.enableOfflineCustomAd = true,
    this.keepAlive = true,
  });

  /// Specific Native Ad Unit ID passed from the widget.
  final String adId;

  /// Height of the native ad container (default: 355).
  final double height;

  /// Native template type.
  final TemplateType templateType;

  /// Optional custom native template style.
  final NativeTemplateStyle? templateStyle;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Optional custom promotional ad model for offline fallback.
  final CustomAdModel? customAd;

  /// Whether offline fallback is enabled.
  final bool enableOfflineCustomAd;

  /// Whether to keep alive in scrollable lists.
  final bool keepAlive;

  @override
  Widget build(BuildContext context) {
    return AdMobNativeWidget(
      adUnitId: adId,
      height: height,
      templateType: templateType,
      templateStyle: templateStyle,
      padding: padding,
      customAd: customAd,
      enableOfflineCustomAd: enableOfflineCustomAd,
      keepAlive: keepAlive,
    );
  }
}

/// Placeholder/Widget for App Icon ad placements.
class SmartAppIconAdView extends StatelessWidget {
  const SmartAppIconAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
