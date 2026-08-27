# flutter_prakash_core 🚀✨

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20%26%20SOLID-success?style=for-the-badge)](#-clean-architecture-principles)

**`flutter_prakash_core`** is an ultimate, enterprise-grade multi-app core engine and hybrid Flutter package framework. Built on **Clean Architecture**, **SOLID principles**, and **zero-boilerplate reactive workflows**, it serves as a plug-and-play architectural foundation across all production Flutter applications. 🏗️⚡

---

## 📑 Table of Contents
- [🌟 Key Architectural Highlights](#-key-architectural-highlights)
- [📦 Installation & Setup](#-installation--setup)
- [🏛️ Architecture & Project Structure](#️-architecture--project-structure)
- [🧩 Core Modules & Capabilities](#-core-modules--capabilities)
  - [⚡ 1. BLoC State Management Engine](#-1-bloc-state-management-engine)
  - [📝 2. Reactive Forms Framework (`BaseFormCubit` & `Field<T>`)](#-2-reactive-forms-framework-baseformcubit--fieldt)
  - [🌐 3. Networking & Error Handling (`Result<T>`)](#-3-networking--error-handling-resultt)
  - [🛠️ 4. DevTools Suite & Runtime Inspectors](#️-4-devtools-suite--runtime-inspectors)
  - [🎨 5. Design System, Tokens & Theme Builder](#-5-design-system-tokens--theme-builder)
  - [💰 6. AdMob Monetization & Cross-Promotion Engine](#-6-admob-monetization--cross-promotion-engine)
  - [🔥 7. Firebase & Observability Suite](#-7-firebase--observability-suite)
  - [🪟 8. UI Components & Overlays (`Toast`, `LoadingOverlay`, `FilePreview`)](#-8-ui-components--overlays-toast-loadingoverlay-filepreview)
  - [🧪 9. Mock Data Generator (`Fake`)](#-9-mock-data-generator-fake)
  - [🪄 10. Extensions & Helpers](#-10-extensions--helpers)
- [📱 Example Application](#-example-application)
- [📄 License & Authors](#-license--authors)

---

## 🌟 Key Architectural Highlights

* 🎯 **Clean Architecture & SOLID Enforced**: Strictly concrete Data Sources and Repositories with zero unnecessary abstractions or domain pollution.
* ⚡ **Complete BLoC State Management**: `BaseCubit`, `BaseBloc`, `BaseUiCubit`, `BasePagingCubit`, and `EnterpriseBlocObserver`.
* 🪄 **One-Shot UI Side-Effects Stream**: Dispatches Toasts, Navigations, and Dialogs cleanly without polluting state trees via `PrakashEffectListener`.
* 📝 **Declarative Reactive Forms**: Type-safe validation chains (`Field<T>`, `Validators`, `ReactiveTextField`, `ReactivePinCodeField`, `ReactiveDropdown`, `ReactiveCheckbox`, `ReactiveSwitch`, `ReactiveFormButton`).
* 🛡️ **Type-Safe Sealed `Result<T>`**: Full failure/exception encapsulation for seamless asynchronous network and storage handling.
* 🎛️ **Built-in DevTools Floating Dock**: Live inspection of HTTP traffic, GraphQL calls, `SharedPreferences`, logs, app storage, and custom overrides.
* 💰 **Comprehensive AdMob & Offline Ad Fallbacks**: Google AdMob Banner, Adaptive Banner, Native templates, App Open, Interstitial, and Rewarded Ads with offline cross-promotions.
* 🎭 **Universal Theme & Design Tokens**: Material 3 Theme Builder (`AppThemeBuilder`), `AppColors`, `AppSpacing`, `AppRadii`, and dynamic color generators.

---

## 📦 Installation & Setup

Add `flutter_prakash_core` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_prakash_core:
    path: ../flutter_prakash_core # Or pub version
```

Run pub get:
```bash
flutter pub get
```

---

## 🏛️ Architecture & Project Structure

`flutter_prakash_core` provides clean, modular components under `lib/src/`:

```
lib/
 └── src/
      ├── admob/       💰 AdMob Services, Banners, Native Widgets, Offline Ad Pool
      ├── base/        🏛️ Base Repository, Base DataSource, Model, Storage
      ├── blocs/       ⚡ Base BLoC/Cubit, Paging, Theme, Locale, AppEvent
      ├── devtools/    🛠️ DevTools Dialog, Floating Dock, Network/Storage Inspectors
      ├── di/          💉 GetIt & Injectable DI Helpers
      ├── extensions/  🪄 Context, String, Int, DateTime, Collection extensions
      ├── fake_data/   🧪 Comprehensive Mock & Placeholder Generator (`Fake`)
      ├── firebase/    🔥 Crashlytics, Analytics, Cloud Messaging, Distribution
      ├── form/        📝 Reactive Form Engine, Field<T>, Validators, Widgets
      ├── loggers/     🪵 Ansi Color Loggers (REST, GraphQL, Supabase, Flutter)
      ├── network/     🌐 Result<T>, Failure, NetworkException
      ├── plugins/     🔌 Native Method Channels & Platform Interface
      ├── routing/     🗺️ PrakashRouter & Route Guards
      ├── theme/       🎨 AppThemeBuilder, AppColors, AppSpacing, AppRadii
      ├── typedefs/    🏷️ Common Functional & Callback Type Aliases
      ├── utilities/   🧰 Debouncer, In-App Review, In-App Update, ColorUtils
      └── widgets/     🪟 Toast, LoadingOverlay, Shimmer, InAppWebView, FilePreview
```

---

## 🧩 Core Modules & Capabilities

### ⚡ 1. BLoC State Management Engine

`flutter_prakash_core` eliminates state boilerplate with lifecycle-safe methods and side-effect streams.

#### 🔄 BaseUiCubit & UiState
Encapsulates async operations (`initial`, `loading`, `success`, `failure`) into a unified UI builder:

```dart
// 1. Define Cubit
@injectable
class UserProfileCubit extends BaseUiCubit<UserProfile> {
  UserProfileCubit(this._repo) : super(const UiState.initial());
  final UserRepository _repo;

  Future<void> fetchProfile(String id) {
    return executeResult(
      call: () => _repo.getUser(id),
      onSuccess: (profile) => emitEffect(ShowToastEffect('Loaded ${profile.name}')),
    );
  }
}

// 2. Consume in UI with Pattern Matching
BlocBuilder<UserProfileCubit, UiState<UserProfile>>(
  builder: (context, state) => switch (state) {
    UiInitial() || UiLoading() => const Center(child: CircularProgressIndicator()),
    UiFailure(:final message) => ErrorRetryWidget(message: message),
    UiSuccess(:final data) => ProfileCard(user: data),
  },
);
```

#### 🚀 Single-Shot UI Effects (`PrakashEffectListener`)
Dispatches one-time events (toasts, navigation routes, alerts) without polluting the state stream:

```dart
PrakashEffectListener.fromCubit(
  cubit: context.read<LoginCubit>(),
  onEffect: (context, effect) {
    if (effect is NavigateEffect) {
      context.router.pushNamed(effect.route);
    }
  },
  child: const LoginFormView(),
);
```

#### 📜 BasePagingCubit & PagingListView
Built-in infinite pagination with automated pull-to-refresh and error handling:

```dart
@injectable
class UserPagingCubit extends BasePagingCubit<User> {
  UserPagingCubit(this._repo);
  final UserRepository _repo;

  @override
  Future<Result<List<User>>> fetchPage(int page, int pageSize) {
    return _repo.getUsers(page: page, limit: pageSize);
  }
}
```

---

### 📝 2. Reactive Forms Framework (`BaseFormCubit` & `Field<T>`)

Declarative, type-safe reactive forms with auto-inferred labels, hints, validation, and submission states.

```dart
// 1. Define State
class LoginFormState extends FormCubitState {
  final Field<String> email;
  final Field<String> password;

  LoginFormState({
    Field<String>? email,
    Field<String>? password,
    super.status = FormStatus.initial,
  })  : email = email ??
            Field(
              labelText: 'Email Address',
              value: '',
              validators: Validators.required().email(),
            ),
        password = password ??
            Field(
              labelText: 'Password',
              value: '',
              validators: Validators.required().minLength(6),
            );

  @override
  List<Field<dynamic>> get fields => [email, password];

  LoginFormState copyWith({
    Field<String>? email,
    Field<String>? password,
    FormStatus? status,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

// 2. Define Cubit
@injectable
class LoginCubit extends BaseFormCubit<LoginFormState, UserProfile> {
  LoginCubit(this._authRepo) : super(LoginFormState());
  final AuthRepository _authRepo;

  void emailChanged(String val) => emit(state.copyWith(email: state.email(val)));
  void passwordChanged(String val) => emit(state.copyWith(password: state.password(val)));

  Future<void> login() async {
    await submitForm(
      call: () => _authRepo.login(state.email.value, state.password.value),
      onSuccess: (user) => emitEffect(ShowToastEffect('Welcome back, ${user.name}!')),
    );
  }
}
```

Available Reactive Form Components:
* 🔤 `ReactiveTextField`
* 🔢 `ReactivePinCodeField` (OTP codes)
* 🔘 `ReactiveCheckbox`
* 🎚️ `ReactiveSwitch`
* 📋 `ReactiveDropdown<T>`
* 📑 `ReactiveSegmentedButton<T>`
* 🎚️ `ReactiveSlider`
* 📅 `ReactiveDatePicker` & ⏰ `ReactiveTimePicker`
* 🔘 `ReactiveRadioGroup<T>`
* 🔘 `ReactiveFormButton`

---

### 🌐 3. Networking & Error Handling (`Result<T>`)

Encapsulate async computations into clean, type-safe sealed `Result<T>` values:

```dart
@lazySingleton
class AuthRepository {
  final AuthRemoteDataSource _remoteSource;
  final AuthLocalDataSource _localSource;

  AuthRepository(this._remoteSource, this._localSource);

  FutureResult<AuthUserModel> login(LoginRequestModel request) {
    return Result.fromAsync(
      call: () async {
        final result = await _remoteSource.login(request);
        await _localSource.saveSession(token: result.token, user: result.user);
        return result.user;
      },
    );
  }
}

// Handling in Cubit / Service:
final result = await authRepo.login(request);
result.when(
  success: (user) => print('Logged in as ${user.name}'),
  error: (failure) => print('Error: ${failure.errorMessage}'),
);
```

---

### 🛠️ 4. DevTools Suite & Runtime Inspectors

Embed a draggable floating inspection dock into your debug builds with a single widget:

```dart
MaterialApp.router(
  builder: (context, child) {
    return DevtoolsFloatingDock(
      enabled: appEnv.isDev,
      // The dock lives above the Navigator, so hand it a key to reach it.
      navigatorKey: _appRouter.navigatorKey,
      child: child ?? const SizedBox.shrink(),
    );
  },
  routerConfig: _appRouter.config(),
);
```

#### Included Inspectors:
* 🌐 **Network Inspector**: Real-time logging of HTTP headers, queries, payloads, and response times.
* ♊ **GraphQL Inspector**: Query/Mutation debugger with execution timing and variables inspector.
* 💾 **Preferences Inspector**: Live viewer & editor for all `SharedPreferences` keys.
* 📦 **Storage Inspector**: Visual directory browser for app sandboxes, cache, and documents.
* 🪵 **Log Inspector**: Filterable ANSI terminal logs with search and tag filters.
* ⚙️ **Custom Options**: Dynamic toggles for environment URLs, mock overrides, and feature flags.

---

### 🎨 5. Design System, Tokens & Theme Builder

Material 3 Theme generation with out-of-the-box light and dark themes:

```dart
MaterialApp.router(
  theme: AppThemeBuilder.buildLightTheme(primaryColor: AppColors.primary),
  darkTheme: AppThemeBuilder.buildDarkTheme(primaryColor: AppColors.primary),
  themeMode: themeMode,
  routerConfig: _appRouter.config(),
);
```

Design Tokens:
```dart
// Colors
AppColors.primary;
AppColors.secondary;
AppColors.success;
AppColors.error;

// Spacing & Radii
AppSpacing.sm; // 8.0
AppSpacing.md; // 16.0
AppSpacing.lg; // 24.0
AppRadii.borderLg; // BorderRadius.circular(16)
```

---

### 💰 6. AdMob Monetization & Cross-Promotion Engine

Unified monetization engine with Google AdMob & offline cross-promotion fallbacks:

```dart
// 1. Initialize AdMob with Custom Offline Ads
await AdMobService.initialize(
  config: AdMobConfig(
    bannerAndroidId: 'ca-app-pub-xxx',
    interstitialAndroidId: 'ca-app-pub-xxx',
    rewardedAndroidId: 'ca-app-pub-xxx',
    isTesting: kDebugMode,
  ),
  autoShowAppOpen: true,
);

// 2. Drop-in Banners
const AdMobBannerWidget();
const AdMobAdaptiveBannerWidget();

// 3. Drop-in Native Ads
const AdMobNativeWidget(templateType: TemplateType.medium);

// 4. Interstitials & Rewarded Video
AdMobService.showInterstitial(onCompleted: () => navigateNext());
AdMobService.showRewarded(onUserEarnedReward: (reward) => giveReward());
```

---

### 🔥 7. Firebase & Observability Suite

Unified manager singletons for Firebase services:

```dart
// Firebase Analytics
FirebaseAnalyticsManager.logEvent(name: 'purchase_success', parameters: {'amount': 99});

// Firebase Crashlytics
FirebaseCrashlyticsManager.recordError(exception, stackTrace, reason: 'Network failure');

// Cloud Messaging & App Distribution
FirebaseCloudMessagingManager.initialize();
FirebaseAppDistributionManager.checkForUpdate();
```

---

### 🪟 8. UI Components & Overlays

#### 🍞 Global Toasts (`Toast`)
Display notifications anywhere without a direct `BuildContext`:

```dart
// Call anywhere:
Toast.success('Profile updated successfully!');
Toast.error('Failed to sync changes.');
Toast.warning('Check your network connection.');
Toast.info('New message received.');
```

#### ⏳ Global Loading Overlay (`LoadingOverlay`)
Block UI during critical background operations:

```dart
LoadingOverlay.show(autoHideInSeconds: 10);
await performHeavySync();
LoadingOverlay.hide();
```

#### 📄 Media & Web Containers
```dart
// In-App Browser
InAppWebViewContainer.show(context, initialUrl: 'https://flutter.dev', title: 'Flutter');

// Interactive Zoomable Image / PDF Viewer
FilePreviewContainer.show(
  context,
  filePath: 'https://example.com/sample.pdf',
  fileType: FileType.pdf,
  sourceType: FileSourceType.network,
  title: 'Contract PDF',
);
```

---

### 🧪 9. Mock Data Generator (`Fake`)

Generate realistic mock data for unit tests, previews, and UI placeholders:

```dart
final name = Fake.fullName;
final email = Fake.email;
final avatar = Fake.avatarUrl();
final image = Fake.imageUrl(width: 800, height: 600);
final price = Fake.price(min: 10, max: 200);
final paragraphs = Fake.paragraphs(3);
final fakeUsers = Fake.list((i) => User(id: Fake.id, name: Fake.fullName), count: 20);
```

---

### 🪄 10. Extensions & Helpers

Ergonomic extensions built directly into Dart core classes:

```dart
// BuildContext Extensions
context.theme;
context.colorScheme;
context.textTheme;
context.isDarkMode;
context.isLightMode;
context.screenWidth;
context.screenHeight;

// String Extensions
'john doe'.capitalize(); // 'John doe'
'john_doe'.toTitleCase(); // 'John Doe'
'alex@company.com'.obscureEmail(); // 'a***x@company.com'
'John Doe'.toInitials(); // 'JD'
'12345'.toNepaliDigits(); // '१२३४५'

// DateTime Extensions
DateTime.now().toIsoDateString(); // '2026-08-26'
DateTime.now().toReadableDate(); // 'Aug 26, 2026'
DateTime.now().subtract(const Duration(minutes: 5)).toTimeAgo(); // '5 minutes ago'
DateTime.now().isToday; // true
```

---

## 📱 Example Application

A complete enterprise-grade sample application demonstrating all patterns can be found in the [`example/`](example/) directory:

```bash
cd example
flutter run -t lib/main_dev.dart
```

---

## 🧪 Verification & QA

```bash
flutter analyze
flutter test
cd example && flutter analyze
```

---

## 📄 License & Authors

Crafted with ❤️ by **Prakash Bahadur Chand**.
Licensed under the [MIT License](LICENSE).