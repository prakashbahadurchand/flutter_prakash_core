# flutter_prakash_core_core_example 📱✨

A production-grade sample application demonstrating the complete capabilities of the **[`flutter_prakash_core`](../)** engine. Built adhering to **Clean Architecture** (no domain layer, direct concrete data sources & repositories), **SOLID principles**, and **reactive form management**.

---

## 🌟 What This Example Showcases

* ⚡ **BLoC State Management**: Clean implementation of `BaseUiCubit`, `FormCubit`, `BasePagingCubit`, and `PrakashEffectListener`.
* 📝 **Reactive Validation**: Registration & Login forms with `ReactiveTextField`, `ReactiveCheckbox`, `ReactiveDropdown`, and `ReactiveFormButton`.
* 🛠️ **DevTools Floating Dock**: Interactive floating dock in debug mode to inspect HTTP calls, GraphQL queries, SharedPreferences, local device storage, and app logs.
* 🎭 **Theme & Localization**: Dynamic system/light/dark theme switching (`ThemeCubit`) and multi-language support (`LocaleCubit` with English, Hindi, and Nepali).
* 🍞 **Zero-Context Overlays**: Global toasts (`Toast.success`, `Toast.error`) and full-screen loading overlays (`LoadingOverlay`).
* 🗺️ **AutoRoute Navigation**: Type-safe navigation with route guards (`ExampleAuthGuard`).
* 🧪 **Mock Data Generation**: Realistic user profiles, addresses, pricing, and avatars generated via `Fake`.

---

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Code Generation (if modifying models/routes/di)
```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### 3. Launch App (Dev or Prod Flavor)
```bash
# Run Development Flavor
flutter run -t lib/main_dev.dart

# Run Production Flavor
flutter run -t lib/main_prod.dart
```

---

## 📂 Project Architecture

```
lib/
 ├── app/              🚀 Root Application orchestration (`app.dart`)
 ├── bootstrap.dart    🌱 App bootstrap, BLoC observer & DI initialization
 ├── core/             🏛️ Core configs: DI, Envs, Router, Theme & L10n
 └── features/         📦 Feature-first modules
      ├── auth/        🔐 Login, Register, Auth Guards & DTOs
      ├── dashboard/   📊 Main dashboard with interactive tabs & DevTools
      ├── demo/        🧪 Data fetching, paging, and RxDart search examples
      ├── onboarding/  👋 Feature showcase & walk-through slider
      ├── settings/    ⚙️ Theme, Language, Privacy Policy & Feedback
      └── splash/      ⚡ Animated startup splash screen
```

