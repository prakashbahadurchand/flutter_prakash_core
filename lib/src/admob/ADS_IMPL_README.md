# 📱 Google AdMob & Smart Cross-Promotion Engine

An enterprise-grade, zero-to-low boilerplate monetization engine for Flutter applications. Built with automatic lifecycle management, background preloading, smart frequency/interval capping, Google AdMob policy compliance, and offline developer cross-promotion fallbacks.

---

## 📋 Table of Contents
- [📱 Google AdMob \& Smart Cross-Promotion Engine](#-google-admob--smart-cross-promotion-engine)
  - [📋 Table of Contents](#-table-of-contents)
  - [🛠️ Platform Setup](#️-platform-setup)
    - [Android (`android/app/src/main/AndroidManifest.xml`)](#android-androidappsrcmainandroidmanifestxml)
    - [iOS (`ios/Runner/Info.plist`)](#ios-iosrunnerinfoplist)
  - [🚀 1-Minute Quick Start](#-1-minute-quick-start)
  - [🚪 App Open Ads](#-app-open-ads)
    - [Manual Trigger (Optional)](#manual-trigger-optional)
  - [📊 Banner \& Adaptive Banner Ads](#-banner--adaptive-banner-ads)
    - [1. Distinct Ad Unit IDs per Screen (`SmartBannerAdView`)](#1-distinct-ad-unit-ids-per-screen-smartbanneradview)
    - [2. Standard Drop-in Banner (Uses Global Config ID)](#2-standard-drop-in-banner-uses-global-config-id)
    - [3. Anchored Responsive Adaptive Banner](#3-anchored-responsive-adaptive-banner)
  - [📰 Native Ads (Zero Native Code)](#-native-ads-zero-native-code)
    - [1. Distinct Native Ad IDs per Screen (`SmartNativeAdView`)](#1-distinct-native-ad-ids-per-screen-smartnativeadview)
    - [2. Custom Native Styling](#2-custom-native-styling)
  - [🎬 Interstitial Ads](#-interstitial-ads)
    - [1-Line Display with Guaranteed Callback \& Frequency Capping](#1-line-display-with-guaranteed-callback--frequency-capping)
  - [🎁 Rewarded Video Ads](#-rewarded-video-ads)
    - [1-Line Display with User Reward Verification](#1-line-display-with-user-reward-verification)
  - [🌐 Offline Custom Cross-Promotion Ads](#-offline-custom-cross-promotion-ads)
    - [Defining Custom Ads](#defining-custom-ads)
  - [💎 Instant Ad-Free / Premium Bypass](#-instant-ad-free--premium-bypass)
  - [🆔 Official Test IDs Reference](#-official-test-ids-reference)
  - [🛡️ AdMob Policy \& Performance Best Practices](#️-admob-policy--performance-best-practices)

---

## 🛠️ Platform Setup

### Android (`android/app/src/main/AndroidManifest.xml`)
Add your AdMob App ID inside the `<application>` tag:

```xml
<manifest>
    <application>
        <!-- Sample AdMob App ID: Replace with your actual AdMob App ID for production -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-3940256099942544~3347511713"/>
    </application>
</manifest>
```

### iOS (`ios/Runner/Info.plist`)
Add your AdMob App ID and SKAdNetwork identifiers inside `<dict>`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~145869519@</string>
<key>SKAdNetworkItems</key>
<array>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>cstr6suwn9.skadnetwork</string>
    </dict>
</array>
```

---

## 🚀 1-Minute Quick Start

Initialize the engine once in your app's `main()` function:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AdMobService.initialize(
    config: AdMobConfig(
      bannerAndroidId: 'ca-app-pub-xxx/yyy',
      interstitialAndroidId: 'ca-app-pub-xxx/yyy',
      rewardedAndroidId: 'ca-app-pub-xxx/yyy',
      appOpenAndroidId: 'ca-app-pub-xxx/yyy',
      nativeAndroidId: 'ca-app-pub-xxx/yyy',
      isTesting: kDebugMode, // Automatically uses official test IDs in debug mode
      customAds: [
        CustomAdModel(
          headerInfo: 'Recommended for you',
          appName: 'Hamro Maya App',
          appPackageName: 'com.princethakuri.hamromaya',
          appMessage: 'Best collection of Nepali Shayari & Quotes.',
          appDetails: 'Hamro Maya brings you the best collection of quotes.',
          appIconPath: 'assets/icons/app_icon.png',
        ),
      ],
    ),
    autoShowAppOpen: true, // Automatically triggers App Open ads on cold start & app resume!
  );

  runApp(const MyApp());
}
```

---

## 🚪 App Open Ads

`AppOpenAdManager` and `AppLifecycleReactor` handle everything automatically:
- Listens to app backgrounding and foreground resumption.
- Preloads ads in the background.
- Tracks 4-hour max cache duration to prevent expired ad policy violations.
- Avoids showing over existing full-screen ads.

### Manual Trigger (Optional)
```dart
AdMobService.showAppOpen(
  onAdDismissed: () => debugPrint('App open ad dismissed'),
  onAdFailedToShow: (error) => debugPrint('Failed: $error'),
);
```

---

## 📊 Banner & Adaptive Banner Ads

### 1. Distinct Ad Unit IDs per Screen (`SmartBannerAdView`)
```dart
// Home Screen Banner
SmartBannerAdView(
  adId: 'ca-app-pub-3940256099942544/6300978111',
  padding: const EdgeInsets.symmetric(vertical: 8),
)

// Details Screen Banner
SmartBannerAdView(
  adId: 'ca-app-pub-3940256099942544/2934735716',
)
```

### 2. Standard Drop-in Banner (Uses Global Config ID)
```dart
const AdMobBannerWidget()
```

### 3. Anchored Responsive Adaptive Banner
```dart
const AdMobAdaptiveBannerWidget()
```

> **⚡ Performance Note:** All banner widgets include built-in `keepAlive: true` to prevent reload flickering and excessive network requests inside `ListView` and `CustomScrollView`.

---

## 📰 Native Ads (Zero Native Code)

Supports Flutter `NativeTemplateStyle` directly without requiring native Android XML or iOS XIB files.

### 1. Distinct Native Ad IDs per Screen (`SmartNativeAdView`)
```dart
// Feed Medium Native Card
SmartNativeAdView(
  adId: 'ca-app-pub-3940256099942544/2247696110',
  height: 355,
  templateType: TemplateType.medium,
)

// Summary / Exit Small Native Bar
SmartNativeAdView(
  adId: 'ca-app-pub-3940256099942544/3986624511',
  height: 90,
  templateType: TemplateType.small,
)
```

### 2. Custom Native Styling
```dart
AdMobNativeWidget(
  adUnitId: 'ca-app-pub-xxx/yyy',
  templateStyle: NativeTemplateStyle(
    templateType: TemplateType.medium,
    mainBackgroundColor: const Color(0xFFFBFBFE),
    callToActionTextStyle: NativeTemplateTextStyle(
      textColor: Colors.white,
      style: NativeTemplateFontStyle.bold,
      size: 16.0,
    ),
  ),
)
```

---

## 🎬 Interstitial Ads

### 1-Line Display with Guaranteed Callback & Frequency Capping
```dart
// Automatically preloads, checks frequency capping, and guarantees onCompleted runs:
AdMobService.showInterstitial(
  onCompleted: () => Navigator.pushNamed(context, '/game-level-2'),
);

// Or using manager alias:
SmartInterstitialAdManager.showAuto(
  onCompleted: () => Navigator.pop(context),
);
```

---

## 🎁 Rewarded Video Ads

### 1-Line Display with User Reward Verification
```dart
AdMobService.showRewarded(
  onUserEarnedReward: (RewardItem reward) {
    unlockBonusCoins(reward.amount.toInt());
    Toast.success('Unlocked ${reward.amount} bonus coins!');
  },
  onAdFailedToShow: (error) {
    Toast.error('Rewarded ad is not ready yet. Please try again.');
  },
);

// Or using manager alias:
SmartRewardedAdManager.showAuto(
  onUserEarnedReward: (reward) => unlockContent(),
);
```

---

## 🌐 Offline Custom Cross-Promotion Ads

When the user is **offline** and Google AdMob cannot load, the widgets seamlessly display developer cross-promotion cards with direct store installation dialogs.

### Defining Custom Ads
```dart
final myCustomAd = CustomAdModel(
  headerInfo: 'Special for you',
  appName: 'Jaleko Dil App',
  appPackageName: 'com.princethakuri.jalekodil',
  appMessage: 'Best collection of Nepali Status & Quotes.',
  appDetails: 'Daily fresh Nepali Status, Shayari and Quotes.',
  appIconPath: 'assets/icons/jaleko_dil.png',
  isAssetImage: true,
  dialogOkText: 'ठिक छ',
  dialogDownloadText: 'डाउनलोड गर्नुहोस्',
  installButtonText: '*** INSTALL NOW ***',
);

// Register into the global pool:
CustomAdPool.registerAds([myCustomAd]);
```

---

## 💎 Instant Ad-Free / Premium Bypass

One switch to disable all banners, native ads, app open ads, and interstitials app-wide:

```dart
// When user purchases premium / ad-free subscription:
AdMobService.setAdFree(true);

// Check ad-free state anywhere:
if (AdMobService.isAdFree) {
  // Pro features enabled
}
```

---

## 🆔 Official Test IDs Reference

Access official Google AdMob test IDs anytime:

| Format | Android Test ID | iOS Test ID |
|---|---|---|
| **Banner** | `AdMobTestIds.bannerAndroid` | `AdMobTestIds.bannerIos` |
| **Interstitial** | `AdMobTestIds.interstitialAndroid` | `AdMobTestIds.interstitialIos` |
| **Rewarded** | `AdMobTestIds.rewardedAndroid` | `AdMobTestIds.rewardedIos` |
| **Rewarded Interstitial** | `AdMobTestIds.rewardedInterstitialAndroid` | `AdMobTestIds.rewardedInterstitialIos` |
| **App Open** | `AdMobTestIds.appOpenAndroid` | `AdMobTestIds.appOpenIos` |
| **Native Advanced** | `AdMobTestIds.nativeAndroid` | `AdMobTestIds.nativeIos` |

```dart
// Platform-aware dynamic getters:
final String bannerId = AdMobTestIds.banner;
final String interstitialId = AdMobTestIds.interstitial;
final String rewardedId = AdMobTestIds.rewarded;
final String appOpenId = AdMobTestIds.appOpen;
final String nativeId = AdMobTestIds.native;
```

---

## 🛡️ AdMob Policy & Performance Best Practices

1. **Keep-Alive in Scrollable Views**:
   Widgets include `AutomaticKeepAliveClientMixin` by default to prevent reloading ads on every scroll up/down.
2. **Cumulative Layout Shift (CLS) Prevention**:
   Fixed sizing prevents content jumping when ads finish loading, protecting against accidental misclicks.
3. **Strict Offline-Only Custom Banners**:
   Custom promotional banners are **never** shown as filler while online or during ad loading, ensuring 100% compliance with Google AdMob inventory policies.
4. **Automatic Memory Leak Prevention**:
   All ad instances are automatically disposed when widgets unmount or when `AdMobService.dispose()` is called.
