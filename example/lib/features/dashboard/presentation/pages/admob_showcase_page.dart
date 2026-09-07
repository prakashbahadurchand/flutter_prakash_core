import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_prakash_ads/flutter_prakash_ads.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

@RoutePage()
class AdMobShowcasePage extends StatefulWidget {
  const AdMobShowcasePage({super.key});

  @override
  State<AdMobShowcasePage> createState() => _AdMobShowcasePageState();
}

class _AdMobShowcasePageState extends State<AdMobShowcasePage> {
  bool _adsEnabled = true;
  final List<String> _eventLogs = [];
  StreamSubscription<dynamic>? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _adsEnabled = AdsManager.isAdsEnabled;

    // Listen to real-time ad telemetry events
    _eventSubscription = AdsManager.adEventStream.listen((event) {
      if (!mounted) return;
      setState(() {
        final timestamp = DateTime.now().toIso8601String().substring(11, 19);
        final log =
            '[$timestamp] ${event.type.name.toUpperCase()} • ${event.format.name}'
            '${event.isPaid ? ' (Earned: ${event.revenueValue} ${event.currencyCode})' : ''}';
        _eventLogs.insert(0, log);
        if (_eventLogs.length > 20) {
          _eventLogs.removeLast();
        }
      });
    });

    // Preload ads via AdsCubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdsCubit>().loadAllAds();
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _toggleAds(bool value) {
    setState(() {
      _adsEnabled = value;
    });
    AdsManager.setAdsEnabled(value);
    Toast.info(
      value
          ? 'Ads Enabled (Standard Monetization Mode)'
          : 'Ad-Free Mode Activated (All Ads Globally Hidden)',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<AdsCubit>();

    return BlocListener<AdsCubit, AdsState>(
      listenWhen: (prev, curr) =>
          curr.snackBarMessage != null &&
          curr.snackBarMessage != prev.snackBarMessage,
      listener: (context, state) {
        final message = state.snackBarMessage;
        if (message != null) {
          if (state.isSuccessMessage) {
            Toast.success(message);
          } else {
            Toast.info(message);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Google AdMob Showcase',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Preload All Ads',
              onPressed: () {
                cubit.loadAllAds();
                Toast.success('Triggered background ad preloading');
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Hero Header Card with Coins & Live Status
            _buildHeaderCard(context),
            const SizedBox(height: 16),

            // Section 1: Monetization Controls & Policy
            _buildSectionTitle('1. Ad Controls & Policy Compliance'),
            const SizedBox(height: 8),
            _buildControlCard(context),
            const SizedBox(height: 20),

            // Section 2: Full-Screen Ad Formats
            _buildSectionTitle('2. Full-Screen Ad Formats'),
            const SizedBox(height: 8),
            _buildFullScreenAdsCard(context, cubit),
            const SizedBox(height: 20),

            // Section 3: Smart Native Ads
            _buildSectionTitle('3. Smart Native Ads (Templates)'),
            const SizedBox(height: 8),
            const Text(
              'Small Native Template (90px) — Ideal for feeds & list tiles:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const SmartNativeAdView(
              templateType: TemplateType.small,
              cornerRadius: 12.0,
            ),
            const SizedBox(height: 16),
            const Text(
              'Medium Native Template (350px) — Rich media with policy badge & CTA:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const SmartNativeAdView(
              templateType: TemplateType.medium,
              cornerRadius: 16.0,
            ),
            const SizedBox(height: 20),

            // Section 4: Telemetry Log
            _buildSectionTitle('4. Live Telemetry & ILRD Event Stream'),
            const SizedBox(height: 8),
            _buildTelemetryCard(context),
            const SizedBox(height: 30),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
              ),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 2),
                  child: Text(
                    'Anchored Adaptive Banner Ad',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                SmartBannerAdView(
                  adSize: AdSize.banner,
                  showOfflineFallback: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.monetization_on_rounded,
                    color: Colors.amber,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'flutter_prakash_ads',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              BlocSelector<AdsCubit, AdsState, int>(
                selector: (state) => state.coins,
                builder: (context, coins) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$coins Coins',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          BlocSelector<AdsCubit, AdsState, String>(
            selector: (state) => state.statusMessage,
            builder: (context, statusMessage) {
              return Text(
                'Status: $statusMessage',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          const Text(
            '100% Policy Compliant • 4-Hour Cache Expiration • 30s Interstitial Throttling • Reactive Ad-Free Mode',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: AppPalette.surface(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Show Ads (IAP Ad-Free Mode)'),
              subtitle: Text(
                _adsEnabled
                    ? 'Ads are enabled across the app tree'
                    : 'Ad-free mode active — All banners & native ads hidden',
                style: const TextStyle(fontSize: 12),
              ),
              value: _adsEnabled,
              onChanged: _toggleAds,
            ),
            const Divider(height: 1),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: Colors.indigo,
              ),
              title: const Text('GDPR / UMP Privacy Form'),
              subtitle: const Text(
                'Revoke or update EU/EEA consent preferences',
                style: TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final formError = await AdsManager.showPrivacyOptionsForm();
                if (formError == null) {
                  Toast.success('Privacy options updated successfully');
                } else {
                  Toast.info('Privacy form: ${formError.message}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenAdsCard(BuildContext context, AdsCubit cubit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: AppPalette.surface(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: BlocSelector<AdsCubit, AdsState, bool>(
                    selector: (state) => state.isInterstitialLoaded,
                    builder: (context, isLoaded) {
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(
                          isLoaded
                              ? Icons.check_circle_rounded
                              : Icons.fullscreen_rounded,
                        ),
                        label: Text(
                          isLoaded ? 'Show Interstitial' : 'Interstitial Ad',
                        ),
                        onPressed: () => cubit.showInterstitialAd(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocSelector<AdsCubit, AdsState, bool>(
                    selector: (state) => state.isRewardedLoaded,
                    builder: (context, isLoaded) {
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(
                          isLoaded
                              ? Icons.check_circle_rounded
                              : Icons.card_giftcard_rounded,
                        ),
                        label: Text(
                          isLoaded ? 'Show Rewarded' : 'Rewarded Ad (+50)',
                        ),
                        onPressed: () => cubit.showRewardedAd(),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: BlocSelector<AdsCubit, AdsState, bool>(
                    selector: (state) => state.isRewardedInterstitialLoaded,
                    builder: (context, isLoaded) {
                      return OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(
                          isLoaded
                              ? Icons.check_circle_outline_rounded
                              : Icons.video_library_rounded,
                        ),
                        label: Text(
                          isLoaded
                              ? 'Show Rewarded Int.'
                              : 'Rewarded Int. (+100)',
                        ),
                        onPressed: () => cubit.showRewardedInterstitialAd(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocSelector<AdsCubit, AdsState, bool>(
                    selector: (state) => state.isAppOpenLoaded,
                    builder: (context, isLoaded) {
                      return OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(
                          isLoaded
                              ? Icons.check_circle_outline_rounded
                              : Icons.launch_rounded,
                        ),
                        label: Text(isLoaded ? 'Show App Open' : 'App Open Ad'),
                        onPressed: () => cubit.showAppOpenAd(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black45 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      child: _eventLogs.isEmpty
          ? const Center(
              child: Text(
                'Waiting for Ad events (impressions, clicks, rewards)...',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _eventLogs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _eventLogs[index],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
