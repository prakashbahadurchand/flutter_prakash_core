import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get_it/get_it.dart';

import 'src/ads/admob_service.dart';
import 'src/core/logger/app_logger.dart';
import 'src/firebase/firebase_engine.dart';
import 'src/graphql/graphql_service.dart';
import 'src/media/audio/audio_player_service.dart';
import 'src/platform/prakash_native_bridge.dart';
import 'src/rest/dio_client.dart';
import 'src/storage/hive_store.dart';
import 'src/storage/key_value_store.dart';
import 'src/supabase/supabase_engine.dart';

export 'src/ads/admob_service.dart';
export 'src/ads/handlers/interstitial_ad_handler.dart';
export 'src/ads/handlers/rewarded_ad_handler.dart';
export 'src/ads/widgets/prakash_native_ad.dart';
export 'src/core/errors/exceptions.dart';
export 'src/core/errors/failures.dart';
export 'src/core/extensions/extensions.dart';
export 'src/core/logger/app_logger.dart';
export 'src/core/result/result_barrel.dart';
export 'src/core/devtools/app_devtools.dart';
export 'src/core/utilities/utilities_barrel.dart';
export 'src/firebase/firebase_engine.dart';
export 'src/graphql/graphql_service.dart';
export 'src/maps/maps_barrel.dart';
export 'src/media/media_engine.dart';
export 'src/platform/prakash_native_bridge.dart';
export 'src/rest/dio_client.dart';
export 'src/services/services_barrel.dart';
export 'src/storage/storage_barrel.dart';
export 'src/supabase/supabase_engine.dart';
export 'src/theme/app_theme_builder.dart';
export 'src/ui/prakash_ui_components.dart';

/// Configuration for the AdMob monetization engine.
class AdMobConfig {
  final bool enabled;
  final String? bannerAdUnitId;
  final String? interstitialAdUnitId;
  final String? rewardedAdUnitId;

  const AdMobConfig({
    this.enabled = false,
    this.bannerAdUnitId,
    this.interstitialAdUnitId,
    this.rewardedAdUnitId,
  });
}

/// Configuration for the media engine.
class MediaConfig {
  final bool enableAudio;
  final bool enablePdf;
  final bool enableImage;

  const MediaConfig({
    this.enableAudio = false,
    this.enablePdf = false,
    this.enableImage = false,
  });
}

/// Ultra-master engine initializer for the `flutter_prakash` core.
///
/// Lazily wires the engines the consuming app opts into. Everything is
/// registered through the provided [getIt] container for testability.
class PrakashEngine {
  PrakashEngine._();

  static Future<void> initialize({
    required GetIt getIt,
    AppEnvironment environment = AppEnvironment.dev,
    RestConfig? restConfig,
    GraphQLConfig? graphqlConfig,
    FirebaseEngineConfig? firebaseConfig,
    SupabaseConfig? supabaseConfig,
    AdMobConfig? adMobConfig,
    MediaConfig? mediaConfig,
    bool enableStorage = false,
    bool enablePlatformChannels = true,
  }) async {
    // 1. Core Logger.
    getIt.registerSingleton<AppLogger>(AppLogger(environment: environment));

    // 2. Native platform bridge.
    if (enablePlatformChannels) {
      getIt.registerSingleton<PrakashNativeBridge>(PrakashNativeBridge());
    }

    // 3. Backend engines.
    if (restConfig != null) {
      getIt.registerSingleton<DioClient>(DioClient(config: restConfig));
    }
    if (graphqlConfig != null) {
      final service = GraphQLService(config: graphqlConfig);
      await service.init();
      getIt.registerSingleton<GraphQLService>(service);
    }
    if (firebaseConfig != null) {
      await FirebaseEngine.initialize(config: firebaseConfig);
    }
    if (supabaseConfig != null) {
      await SupabaseEngine.initialize(supabaseConfig);
    }

    // 4. AdMob monetization engine.
    if (adMobConfig != null && adMobConfig.enabled) {
      await MobileAds.instance.initialize();
      final service = AdMobService();
      getIt.registerSingleton<AdMobService>(service);
    }

    // 5. Media engine (audio/pdf/image).
    if (mediaConfig != null) {
      if (mediaConfig.enableAudio) {
        getIt.registerSingleton<AudioPlayerService>(
          AudioPlayerService.instance,
        );
      }
    }

    // 6. Storage engines (key-value + hive object store).
    if (enableStorage) {
      getIt.registerSingleton<KeyValueStore>(KeyValueStore());
      getIt.registerSingleton<HiveStore>(HiveStore.instance);
    }
  }

  /// A best-effort graceful shutdown for the optional native & player engines.
  static Future<void> dispose(GetIt getIt) async {
    if (getIt.isRegistered<AudioPlayerService>()) {
      await getIt<AudioPlayerService>().dispose();
    }
  }
}
