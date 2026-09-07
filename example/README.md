# flutter_prakash_core_example 📱✨

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20%26%20SOLID-success?style=for-the-badge)](#-project-architecture)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A production-grade, enterprise sample application demonstrating the complete capabilities of **[`flutter_prakash_core`](../)** and **[`flutter_prakash_ads`](https://pub.dev/packages/flutter_prakash_ads)**. Built adhering strictly to **Clean Architecture** (no domain layer, direct concrete data sources & repositories), **SOLID principles**, and **reactive form management**. 🏗️⚡

---

## 🌟 What This Example Showcases

* ⚡ **BLoC State Management**:
  * `BaseUiCubit` & `UiState` lifecycle (`initial`, `loading`, `success`, `failure`).
  * `BaseFormCubit` & `Field<T>` with declarative chained `Validators`.
  * `BasePagingCubit` for infinite scrolling lists with pull-to-refresh & optimistic item deletion.
  * `FpEventTransformers.debounce` for 300ms real-time search inputs.
  * `FpEffectListener` for single-shot UI side-effects (toasts, navigation).
* 🔐 **Full Authentication Suite** (`features/auth/`):
  * **Login**: Email & password validation, remember me, and social buttons.
  * **Register**: Full name, email, password strength, match verification, terms consent.
  * **Forgot Password**: Email submission to dispatch a 6-digit recovery OTP code.
  * **Email Verification**: 6-digit `ReactivePinCodeField` with a 60s countdown timer & resend.
  * **Reset Password**: OTP verification with new password configuration.
  * **Change Password**: In-app security settings flow.
* 💰 **Monetization & AdMob Integration** (`flutter_prakash_ads`):
  * Automated `AdManager` initialization and GDPR/UMP consent management.
  * Adaptive `BannerAdView`.
  * `SmartNativeAdView` (Small 90px and Medium 350px templates).
  * `AdMobShowcasePage` demonstrating Interstitial, Rewarded, and Rewarded Interstitial ads with live ILRD telemetry.
* 🛠️ **DevTools Floating Dock**:
  * Draggable in-app overlay dock (`DevtoolsFloatingDock`) giving instant access to the DevTools inspector from any screen in dev mode.
  * Network requests, `SharedPreferences`, local file storage, and ANSI logs.
* 🎭 **Theme & Localization**:
  * Dynamic system/light/dark theme switching (`ThemeCubit`).
  * Multi-language support (`LocaleCubit` with English, Hindi, and Nepali).
* 🍞 **Zero-Context Overlays & Universal Pages**:
  * Global toasts (`Toast.success`, `Toast.error`, `Toast.warning`, `Toast.info`).
  * Full-screen loading overlay (`LoadingOverlay.show()` / `LoadingOverlay.hide()`).
  * Media preview (`FilePreviewPage` for image zoom & PDF viewing).
  * In-app web browser (`InAppWebViewPage` with progress bar & action controls).
  * User feedback submission (`FeedbackPage` with reactive validation).
* 🗺️ **Type-Safe Navigation**:
  * `AutoRoute` with route guards (`ExampleAuthGuard`).
  * Splash screen dynamic routing based on session tokens and onboarding state.

---

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Code Generation (if modifying routes, models, or DI)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Launch App (Flavours)
```bash
# Run Development Flavour
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=.env.dev

# Run Production Flavour
flutter run -t lib/main_prod.dart --flavor prod --dart-define-from-file=.env.prod
```

---

## 📂 Project Architecture

```
example/lib/
├── app.dart                               # Root app with ThemeCubit, LocaleCubit, AuthCubit, & DevtoolsFloatingDock
├── bootstrap.dart                         # Global error logger, EnterpriseBlocObserver, Ads initialization
├── main.dart                              # Default entrypoint
├── main_dev.dart                          # Dev flavour entrypoint
├── main_prod.dart                         # Prod flavour entrypoint
├── config/                                # App-wide static configuration
│   ├── constants/app_constants.dart       # App versions, timeouts, storage keys
│   ├── envs/ (app_env.dart, env_dev.dart, env_prod.dart, envs.dart)
│   ├── themes/ (app_colors.dart, app_theme.dart)
│   └── config.dart                        # Barrel file
├── core/                                  # Common utilities & system singletons
│   ├── ads/ (ads.dart, my_ad_service.dart, cubit/ads_cubit.dart)
│   ├── di/ (injection.dart, register_module.dart)
│   ├── l10n/ (l10n.dart)
│   ├── router/ (app_router.dart, app_router.gr.dart, guards/auth_guard.dart)
│   └── core.dart                          # Barrel file
└── features/
    ├── splash/                            # App launch, initialization, version check
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── blocs/
    │       ├── pages/
    │       └── widgets/
    ├── onboarding/                        # Intro slides, initial setup screens
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── blocs/
    │       ├── pages/
    │       └── widgets/
    ├── auth/                              # Auth: login, register, forgot/reset password, email verification
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── blocs/
    │       ├── pages/
    │       └── widgets/
    ├── dashboard/                         # Core app experience & main navigation hub
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── blocs/
    │       ├── pages/
    │       └── widgets/
    ├── settings/                          # User preferences, app info, notification toggles
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── blocs/
    │       ├── pages/
    │       └── widgets/
    └── common/                            # Universal utility screens used across features
        ├── data/
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/
        └── presentation/
            ├── blocs/
            ├── pages/
            │   ├── file_preview/
            │   ├── inapp_webview/
            │   ├── privacy_policy/
            │   ├── terms_and_conditions/
            │   └── feedback/
            └── widgets/
```

---

## 🧪 Quality & Verification

```bash
# Analyze Example Code
flutter analyze

# Analyze Core Engine
cd .. && flutter analyze

# Run Full Test Suite
flutter test
```

---

## 📄 License & Authors

Crafted with ❤️ by **Prakash Bahadur Chand**.
Licensed under the [MIT License](../LICENSE).
