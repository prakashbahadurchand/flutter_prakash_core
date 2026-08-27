import 'package:flutter/material.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/models/onboarding_item_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class OnboardingLocalDataSource {
  final SharedPreferences _prefs;

  const OnboardingLocalDataSource(this._prefs);

  List<OnboardingItemModel> getOnboardingSlides() {
    return const [
      OnboardingItemModel(
        title: 'Omni-Backend Engine',
        subtitle:
            'Built-in REST (Dio), GraphQL, Firebase & Supabase engines ready for enterprise scaling out-of-the-box.',
        icon: Icons.cloud_sync_rounded,
        badge: 'ARCHITECTURE',
        gradient: [AppPalette.blue, AppPalette.blueDark],
      ),
      OnboardingItemModel(
        title: 'Monetization & Media',
        subtitle:
            'Seamless Google AdMob banner, interstitial, rewarded & native ads paired with Audio & PDF viewing utilities.',
        icon: Icons.monetization_on_rounded,
        badge: 'MONETIZATION',
        gradient: [AppPalette.success, AppPalette.successDark],
      ),
      OnboardingItemModel(
        title: 'Enterprise Core Utilities',
        subtitle:
            'ANSI color loggers, mock data generators, BLoC state observers, and clean modular feature scaffolding.',
        icon: Icons.build_circle_rounded,
        badge: 'UTILITIES',
        gradient: [AppPalette.secondary, AppPalette.secondaryDark],
      ),
    ];
  }

  Future<bool> setOnboardingCompleted() async {
    return _prefs.setBool(AppConstants.keyOnboardingCompleted, true);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
  }
}
