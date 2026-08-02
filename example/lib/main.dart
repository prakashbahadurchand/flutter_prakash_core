import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

import 'app.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize only the engines this demo opts into. Every engine is optional
  // and lazy-wired through the GetIt container.
  await PrakashEngine.initialize(
    getIt: getIt,
    environment: AppEnvironment.dev,
    restConfig: const RestConfig(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    ),
    adMobConfig: const AdMobConfig(enabled: true),
    mediaConfig: const MediaConfig(enableAudio: true),
    enableStorage: true,
    enablePlatformChannels: true,
  );

  // Register the feature-level Clean Architecture graph (domain/data/app).
  configureDependencies(getIt);

  runApp(const FlutterPrakashExample());
}