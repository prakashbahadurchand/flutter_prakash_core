import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

import '../../../../shared/widgets/wrappers.dart';

/// Presents the AdMob feature.
///
/// Clean Architecture **presentation** layer. Uses the documented Google Test
/// ad unit IDs; replace with production IDs before release.
class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  late final InterstitialAdHandler _interstitial = InterstitialAdHandler();
  late final RewardedAdHandler _rewarded = RewardedAdHandler();

  @override
  void initState() {
    super.initState();
    _interstitial.loadAd(AdMobTestAds.interstitialAndroid);
    _rewarded.loadAd(AdMobTestAds.rewardedAndroid);
  }

  @override
  void dispose() {
    _interstitial.dispose();
    _rewarded.dispose();
    super.dispose();
  }

  void _showInterstitial() {
    final messenger = ScaffoldMessenger.of(context);
    _interstitial.show(
      onDismissed: () => messenger.showSnackBar(
        const SnackBar(content: Text('Interstitial closed')),
      ),
    );
  }

  Future<void> _showRewarded() async {
    final messenger = ScaffoldMessenger.of(context);
    final reward = await _rewarded.show();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          reward != null
              ? 'Reward granted: ${reward.amount} ${reward.type}'
              : 'No rewarded ad available',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Ads (AdMob)',
      child: Column(
        children: [
          DemoCard(
            title: 'Banner Ad',
            child: Align(
              child: PrakashBannerAd(adUnitId: AdMobTestAds.bannerAndroid),
            ),
          ),
          DemoCard(
            title: 'Interstitial Ad',
            child: FilledButton.icon(
              onPressed: _showInterstitial,
              icon: const Icon(Icons.fullscreen),
              label: const Text('Show Interstitial'),
            ),
          ),
          DemoCard(
            title: 'Rewarded Ad',
            child: FilledButton.icon(
              onPressed: _showRewarded,
              icon: const Icon(Icons.card_giftcard),
              label: const Text('Show Rewarded'),
            ),
          ),
          DemoCard(
            title: 'Native Ad',
            child: PrakashNativeAd(adUnitId: AdMobTestAds.nativeAndroid),
          ),
        ],
      ),
    );
  }
}