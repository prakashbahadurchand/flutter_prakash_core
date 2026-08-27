import 'package:flutter_prakash_core/src/admob/app_open_ad_manager.dart';
import 'package:flutter_prakash_core/src/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Listens for app foreground / background events and displays App Open ads automatically.
class AppLifecycleReactor {
  AppLifecycleReactor({required this.appOpenAdManager});

  final AppOpenAdManager appOpenAdManager;
  bool _hasBeenBackgrounded = false;
  bool _isListening = false;

  /// Starts listening to app state transitions (background / foreground).
  void listenToAppStateChanges() {
    if (_isListening) return;
    _isListening = true;

    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.listen(_onAppStateChanged);
  }

  void _onAppStateChanged(AppState appState) {
    FlutterLogger.info('AppLifecycleReactor state: $appState', tag: 'ADMOB');

    if (appState == AppState.background) {
      _hasBeenBackgrounded = true;
      // Pre-fetch next ad in background so it is ready immediately when foregrounded
      if (!appOpenAdManager.isAdAvailable) {
        appOpenAdManager.loadAd();
      }
    } else if (appState == AppState.foreground && _hasBeenBackgrounded) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}
