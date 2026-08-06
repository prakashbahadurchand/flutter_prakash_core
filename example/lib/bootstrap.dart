import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/core/di/injection.dart';

Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure enterprise BLoC observer for debug logging
  Bloc.observer = EnterpriseBlocObserver(
    logEvents: true,
    logTransitions: false,
    logChange: false,
  );

  // Initialize Flutter Prakash logger
  FlutterLogger.isEnabled = true;
  logInfo('Initializing Flutter Prakash Example Bootstrap', tag: 'BOOTSTRAP');

  // Configure Dependency Injection container
  await configureDependencies();
  logInfo('Dependencies successfully initialized', tag: 'BOOTSTRAP');

  runApp(builder());
}
