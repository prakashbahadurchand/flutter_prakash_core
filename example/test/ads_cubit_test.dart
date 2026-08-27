import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_ads/flutter_prakash_ads.dart';
import 'package:flutter_prakash_core_example/core/ads/cubit/ads_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AdsService adsService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    adsService = AdsServiceImpl();
  });

  group('AdsCubit', () {
    test('initial state has default status and 0 coins', () {
      final cubit = AdsCubit(adsService: adsService);
      expect(cubit.state.coins, 0);
      expect(cubit.state.isInterstitialLoaded, isFalse);
      expect(cubit.state.isRewardedLoaded, isFalse);
      cubit.close();
    });

    test('userEarnedReward grants coins and updates state', () {
      final cubit = AdsCubit(adsService: adsService);
      cubit.userEarnedReward(50);

      expect(cubit.state.coins, 50);
      expect(cubit.state.snackBarMessage, contains('+50 Coins'));

      cubit.userEarnedReward(100);
      expect(cubit.state.coins, 150);
      cubit.close();
    });

    test('updateAdStatus sets statusMessage correctly', () {
      final cubit = AdsCubit(adsService: adsService);
      cubit.updateAdStatus('Custom Ad Status Message');

      expect(cubit.state.statusMessage, 'Custom Ad Status Message');
      cubit.close();
    });
  });
}
