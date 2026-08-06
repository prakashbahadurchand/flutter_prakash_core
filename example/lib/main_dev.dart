import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/bootstrap.dart';
import 'package:flutter_prakash_example/src/config/env/app_config.dart';
import 'package:flutter_prakash_example/src/config/routes/app_router.dart';

void main() {
  AppConfig.init(
    appName: const String.fromEnvironment('APP_NAME', defaultValue: 'Flutter Prakash DEV'),
    environment: AppEnvironment.dev,
    baseUrl: const String.fromEnvironment('BASE_URL', defaultValue: 'https://dev-api.prakash.dev'),
  );

  bootstrap(
    () => AppRestartWrapper(
      onRestart: () async {
        logInfo('App restarted via AppRestartWrapper', tag: 'RESTART');
      },
      child: const ExampleApp(),
    ),
  );
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.instance.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemeBuilder.buildLightTheme(),
      darkTheme: AppThemeBuilder.buildDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: _appRouter.config(),
    );
  }
}
