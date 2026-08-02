# flutter_prakash 🚀

**`flutter_prakash`** is an ultimate, enterprise-grade multi-app core engine and hybrid Flutter plugin framework. Built on **Clean Architecture**, **SOLID** principles and **zero-tight-coupling** dynamic exports, it serves as a plug-and-play foundation across all present and future Flutter applications.

```
+------------------------------------------+
|            Consuming Flutter App           |
+------------------------------------------+
                  |
         PrakashEngine.initialize()
                  |
   +--------+--------+--------+--------+--------+--------+--------+
   |  Core  | Network |  AdMob  | Media  |  Maps  |Storage  |Services|
   +--------+--------+--------+--------+--------+--------+--------+
```

---

## ✨ Feature Overview

- 🌐 **Omni-Backend**: REST (Dio) · GraphQL (Http/WS) · Firebase (Auth, Firestore, FCM, Crashlytics, Remote Config) · Supabase (Auth, Realtime, Storage, Edge).
- 💰 **AdMob Monetization**: Banner · Interstitial · Rewarded · Native ads (test IDs included).
- 🎵 **Media Engine**: Audio player · PDF viewer · Image compression & picker.
- 🗺️ **Maps & Geo**: `flutter_map` wrapper · marker clustering · location + permissions.
- 💾 **Storage**: typed key-value (`shared_preferences`) + object store (`hive_ce`).
- 🔌 **Native Bridge**: extensible Android (Kotlin) & iOS (Swift) method channels.
- 🧩 **Services**: Deep Links · Share · Home Widgets · Speech-to-Text · QR · Notifications · Permissions · Device Info.
- 🛡️ **Core**: `Result<T, Failure>` & `AsyncValue<T>`, exceptions, extensions, logger, **DI via GetIt**.
- 🎨 **Design System**: M3 theme builder, design tokens, universal image loader, shimmers, paginated lists.

---

## 📦 Setup

```yaml
dependencies:
  flutter_prakash:
    git:
      url: https://github.com/prakashbahadurchand/flutter_prakash
```
or for local development:

```yaml
dependencies:
  flutter_prakash:
    path: ../flutter_prakash
```

Then `flutter pub get`. Run the bundled demo:

```bash
cd example && flutter run
```

---

## 🚀 Quick Start

### 1. Initialize the Engine

```dart
import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrakashEngine.initialize(
    getIt: getIt,
    environment: AppEnvironment.dev,

    // Backends — enable only what you use.
    restConfig: const RestConfig(baseUrl: 'https://api.example.com'),
    // graphqlConfig: GraphQLConfig(httpEndpoint: 'https://api.example.com/graphql'),
    // firebaseConfig: const FirebaseEngineConfig(enableAuth: true),
    // supabaseConfig: const SupabaseConfig(url: '...', publishableKey: '...'),

    adMobConfig: const AdMobConfig(enabled: true),
    mediaConfig: const MediaConfig(enableAudio: true),
    enableStorage: true,
    enablePlatformChannels: true,
  );

  runApp(
    MaterialApp(
      theme: AppThemeBuilder.buildLightTheme(),
      darkTheme: AppThemeBuilder.buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const MyApp(),
    ),
  );
}
```

---

## 🔌 Modular Entrypoints

Import only what you need:

```dart
import 'package:flutter_prakash/flutter_prakash.dart'; // All-in-one
import 'package:flutter_prakash/core.dart';              // Result, AsyncValue, extensions, logger
import 'package:flutter_prakash/rest.dart';
import 'package:flutter_prakash/graphql.dart';
import 'package:flutter_prakash/firebase.dart';
import 'package:flutter_prakash/supabase.dart';
import 'package:flutter_prakash/ads.dart';
import 'package:flutter_prakash/media.dart';
import 'package:flutter_prakash/maps.dart';
import 'package:flutter_prakash/storage.dart';
import 'package:flutter_prakash/services.dart';
import 'package:flutter_prakash/platform.dart';
import 'package:flutter_prakash/theme.dart';
import 'package:flutter_prakash/ui.dart';
```

---

## 🛡️ Core: Result & AsyncValue

Eliminate try/catch boilerplate with a sealed `Result`:

```dart
Future<Result<List<Post>>> fetchPosts(DioClient client) async {
  try {
    final resp = await client.dio.get('/posts');
    final posts = (resp.data as List).map(Post.fromJson).toList();
    return Result.success(posts);
  } on DioException catch (e) {
    return Result.failure(ServerFailure(e.message ?? 'Server error'));
  } catch (e) {
    return Result.failure(UnknownFailure('$e'));
  }
}

// Consume:
final result = await fetchPosts(client);
result.fold(
  onSuccess: (posts) => debugPrint('Got ${posts.length} posts'),
  onFailure: (failure) => debugPrint('Failed: ${failure.message}'),
);
```

Bridge `Result` to reactive UI state with `AsyncValue`:

```dart
AsyncValue<Post> _state = const AsyncValue.idle();

return _state.fold(
  onIdle: () => const Text('Press fetch'),
  onLoading: () => const CircularProgressIndicator(),
  onData: (post) => Text(post.title),
  onError: (failure) => Text(failure.message),
);

// result.toAsyncValue() // Result<T> → AsyncValue<T>
```

---

## 🌐 REST Engine

The `DioClient` adds connectivity checks, auth-token injection/refresh, and
retry on a single interceptor. Access it from DI:

```dart
final client = getIt.get<DioClient>();

final response = await client.dio.get(
  '/users?limit=10',
  options: Options(responseType: ResponseType.json),
);
```

Custom auth/logic strategy by passing an `IAuthTokenStrategy`:

```dart
class MyAuthStrategy implements IAuthTokenStrategy {
  @override Future<String?> getAccessToken() async => store.read('token');
  @override Future<bool> refreshTokens() async => true;
  @override Future<void> onAuthenticationFailed() async {}
}

restConfig: RestConfig(
  baseUrl: 'https://api.example.com',
  authTokenStrategy: MyAuthStrategy(),
),
```

---

## ♊ GraphQL

```dart
final graphql = getIt.get<GraphQLService>();

// Query
final res = await graphql.query(
  r'''
    query($id: ID!) { user(id: $id) { name email } }
  ''',
  variables: {'id': '1'},
);

// Mutation
final mut = await graphql.mutate(
  r'''
    mutation($input: UserInput!) { createUser(input: $input) { id } }
  ''',
  variables: {'input': {...}},
);
```

Configure an HTTP + optional WebSocket endpoint for subscriptions:

```dart
graphqlConfig: GraphQLConfig(
  httpEndpoint: 'https://api.example.com/graphql',
  wsEndpoint: 'wss://api.example.com/graphql', // enables subscriptions
  getToken: () async => await auth.token(),
),
```

---

## 🔥 Firebase

```dart
await FirebaseEngine.initialize(
  config: const FirebaseEngineConfig(
    enableAuth: true,
    enableFirestore: true,
    enableMessaging: true,
    enableCrashlytics: true,
    enableRemoteConfig: true,
  ),
);
```

Helpers:

```dart
// Firestore
final snapshots = await FirebaseEngine.getCollection('posts');

// Remote config
final banner = await FirebaseEngine.getRemoteString('home_banner');
```

---

## 🐘 Supabase

```dart
await SupabaseEngine.initialize(
  const SupabaseConfig(url: 'https://xxx.supabase.co', publishableKey: 'anon_key'),
);

final rows   = await SupabaseEngine.select('profiles');           // Table select
final stream = SupabaseEngine.streamTable('messages', primaryKey: 'id'); // Realtime
```

---

## 💰 AdMob Monetization

Initialize & register the service in `initialize` with `adMobConfig`.
Use the bundled **test ad unit IDs** during development:

```dart
final bannerId = AdMobTestAds.bannerAndroid; // swap for production IDs
```

### Banner

```dart
PrakashBannerAd(adUnitId: AdMobTestAds.bannerAndroid)
```

### Interstitial

```dart
final interstitial = InterstitialAdHandler();
await interstitial.loadAd(AdMobTestAds.interstitialAndroid);

void showAd() {
  interstitial.show(onDismissed: () => debugPrint('ad closed'));
}
```

### Rewarded

```dart
final rewarded = RewardedAdHandler();
await rewarded.loadAd(AdMobTestAds.rewardedAndroid);

final reward = await rewarded.show();
if (reward != null) debugPrint('Got ${reward.amount} ${reward.type}');
```

### Native

```dart
PrakashNativeAd(adUnitId: AdMobTestAds.nativeAndroid)
```

---

## 🎵 Media Engine

### Audio

```dart
final audio = getIt.get<AudioPlayerService>();
await audio.playUrl('https://example.com/song.mp3');
await audio.pause();
await audio.seek(const Duration(seconds: 30));
audio.player.onPlayerStateChanged.listen((state) { /* UI */ });
```

### Image pick & compress

```dart
final file = await ImageHelper.pickAndCompress(
  ImageSource.gallery,
  options: const ImageCompressOptions(quality: 70, maxWidth: 1024),
);
```

### PDF

```dart
PrakashPdfViewer(
  filePath: '/path/to/doc.pdf',
  swipeHorizontal: true,
)
```

---

## 🗺️ Maps & Location

```dart
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Basic map
PrakashMapWidget(
  initialCenter: const LatLng(27.7172, 85.324),
  initialZoom: 12,
  markers: [
    Marker(
      point: const LatLng(27.7172, 85.324),
      width: 40,
      height: 40,
      child: const Icon(Icons.location_on, color: Colors.red),
    ),
  ],
)

// Clustering & location
final loc = LocationService();
final granted = await loc.requestPermission();
final latLng  = await loc.getCurrentLocation(); // throws if 'unavailable'

FlutterMap(
  options: MapOptions(initialCenter: center, initialZoom: 10),
  children: [
    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.myapp'),
    ClusterMarkerLayer(markers: myMarkers),
  ],
)
```

---

## 💾 Storage

```dart
// Key–value (shared_preferences)
final kv = getIt.get<KeyValueStore>();
await kv.setString('token', 'abc');
final token = await kv.getString('token');

// Object store (Hive)
final box = await HiveStore.instance.openBox<dynamic>('posts');
await box.put('1', {'name': 'Ada', 'likes': 120});
final post = box.get('1');
```

---

## 🧩 Services

```dart
// Deep link / share
await DeepLinkService.launch('https://flutter.dev');
await DeepLinkService.call('+9779800000000');
await DeepLinkService.email('a@b.co', subject: 'Hello');
await DeepLinkService.share('Check out flutter_prakash!');

// Notifications
await LocalNotificationService.initialize();
await LocalNotificationService.show(1, 'Title', 'Body');

// Permissions
final granted = await PermissionService.requestOne(PermissionService.camera);

// Home widget update
await HomeWidgetService.updateData({'score': 100});

// QR
QRService.render('https://flutter.dev', size: 180);
```

---

## 🎨 UI / Design System

```dart
// Universal image loader (network/SVG/asset + shimmer fallback)
PrakashImage(imagePath: 'https://picsum.photos/400/150',
             width: 300, height: 200, fit: BoxFit.cover);

// Shimmer skeleton
ShimmerBox(width: 120, height: 14);

// Infinite paginated list
PrakashPaginatedList<Post>(
  fetchPage: (page) async {
    final data = await dio.get('/posts?page=$page');
    return PageResult(items: [...data], page: page, totalPages: 5);
  },
  itemBuilder: (context, post, index) => ListTile(title: Text(post.title)),
);

// Design tokens
AppColors.primary     // Color
AppSpacing.md         // double
AppRadii.lg           // double
AppElevation.low      // double
```

---

## 🧪 Verification & QA

```bash
flutter analyze
flutter test       # zero issues expected
cd example && flutter run
```

---

## 📄 License

MIT © Prakash Bahadur Chand.