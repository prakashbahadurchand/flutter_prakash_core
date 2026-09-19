## 1.0.12

* **Enterprise Admin Dashboard Framework**:
  * **Adaptive Layout Scaffold**: Added modular `AdminPanelScaffold` featuring collapsible desktop navigation rails, nested submenus, persistent top headers, user profile dropdowns, and mobile drawers.
  * **Domain Types & RBAC Navigation**: Added `AdminNavItem` supporting unique IDs, routes, role-based access control (RBAC), live badges, dividers, and hierarchical child menus.
  * **Theme & Style Defaults**: Added `AdminThemeConfig` with production-ready defaults (`AdminThemeConfig.defaultConfig()`) and `AdminTheme` InheritedWidget.
  * **Responsive Grid System**: Added `ResponsiveGridRow` and `ResponsiveGridCol` 12-column responsive layout engine and auto-adapting `ResponsiveGrid`.
  * **Enterprise KPI Metric Cards**: Added `MetricCard` with multi-variant styling, trend trajectories, inverted sentiment support, status badges, and skeleton shimmer loading.
  * **Standardized Page Headers**: Added `PageHeader` with interactive dynamic breadcrumbs, subtitles, and responsive action bar wrapping.
  * **Enterprise Tabular Wrapper**: Added `DataTableCard` with live search, filter slots, refresh controls, export actions, loading overlays, empty and error state builders.
* **Toast & Notification Engine**: Enhanced responsive viewport bounds, margins, and dismissal physics in `ToastOverlay`.
* **Example & Web Experience**:
  * Added custom enterprise web loader in `example/web/index.html` with animated progress bar and smooth frame-detection exit.
  * Complete showcase of `AdminPanelShellPage` and `AdminOverviewPage` with interactive mock business data and `ViewEditDeleteButton`.

## 1.0.11

* **Dependency Updates**: Upgraded packages across the core and example suite (`equatable` to `^3.0.0`, `file_picker` to `^13.1.0`, `home_widget` to `^0.10.0`, `skeletonizer` to `^3.0.0`).
* **Exports & Accessibility**: Exported `src` library and `pretty_dio_logger` through top-level entry point.
* **Example Enhancements**: Configured dependency overrides and upgraded dependencies for seamless interoperability.
* **Maintenance**: Excluded environment and local config files in `.pubignore`.

## 1.0.10

* **BLoC State Management Engine**: Integrated zero-boilerplate `BaseBloc`, `BaseCubit`, `BaseUiCubit`, `BaseFormCubit` (with reactive forms), and `BasePagingCubit`.
* **Single-Shot Side-Effects Channel**: Added `FpEffect` stream channel and `FpEffectListener` for handling Toasts, Navigation, and Dialogs.
* **Reactive Form & Validator Suite**: Declarative `Field<T>`, chained fluent `Validators`, and reactive UI components (`ReactiveTextField`, `ReactivePinCodeField`, etc.).
* **Supabase Suite**: Added `SupabaseEngine` supporting `supabase_flutter` v2.8+ Auth, Realtime DB, Postgrest CRUD, and Storage.
* **Firebase Suite**: Added unified `FirebaseEngine` manager initializing Auth, Firestore, Messaging, Crashlytics, Remote Config, Analytics, and Performance.
* **Hot App Restart Engine**: Added `AppRestartWrapper` enabling key-based hot app resets and cache re-initialization.
* **Design System & Theme Engine**: Added `AppThemeBuilder` with tokenized `AppColors`, `AppSpacing`, `AppRadii`, and `AppElevation`.
* **Clean Architecture Helpers**: Added `BaseRepository.safeCall<T>()` and `ResultToUiStateX.toUiState()` extension.
* **Interactive Example App**: Refactored example app with Clean Architecture, `LoginCubit`, `ExampleAuthGuard`, and 4 interactive BLoC engine tabs.

## 0.0.1

* Ultimate Enterprise Multi-App Core Engine & Hybrid Plugin Framework.
* Core: `Result<T, Failure>`, `AsyncValue<T>`, exceptions, extensions, logger, GetIt DI.
* REST (Dio) engine with auth-token injection & retry; GraphQL HTTP + WS engine.
* Firebase (Auth, Firestore, FCM, Crashlytics, Analytics, Remote Config) & Supabase engines.
* AdMob monetization: banner, interstitial, rewarded, native ads with bundled test IDs.
* Media engine: audio player, PDF viewer, image picker & compressor.
* Maps & location: `flutter_map` wrapper, marker clustering, permission + location services.
* Storage: typed key-value (`shared_preferences`) and object store (`hive_ce`).
* Typed native bridge (`IPrakashNativeBridge`) with Android (Kotlin) and iOS (Swift) handlers:
  platform version, device model, current location.
* Services: deep links, share, home widgets, speech-to-text, QR, notifications, permissions, device info.
* Theme & UI: M3 theme builder, design tokens, universal image loader, shimmers, paginated lists.
* Full-featured example app covering every engine.