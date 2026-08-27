import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/app/app.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';

Future<void> bootstrap({String? environment}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure enterprise BLoC observer for debug logging
  Bloc.observer = const EnterpriseBlocObserver(
    logEvents: true,
    logTransitions: false,
    logChange: false,
  );

  // Initialize Flutter Prakash logger
  FlutterLogger.isEnabled = true;
  logInfo('Initializing Flutter Prakash Example Bootstrap', tag: 'BOOTSTRAP');

  // Configure Dependency Injection container
  await configureDependencies(environment: environment);
  logInfo(
    'Dependencies successfully initialized for env: $environment',
    tag: 'BOOTSTRAP',
  );

  runApp(MyApp());
}
