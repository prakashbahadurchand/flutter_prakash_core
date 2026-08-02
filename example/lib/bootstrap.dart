import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Flutter Prakash logger & setup
  FlutterLogger.isEnabled = true;
  logInfo('Initializing Flutter Prakash Example Bootstrap', tag: 'BOOTSTRAP');

  runApp(builder());
}
