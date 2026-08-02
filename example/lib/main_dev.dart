import 'package:flutter/material.dart';
import 'package:flutter_prakash_example/bootstrap.dart';
import 'package:flutter_prakash_example/src/config/routes/app_router.dart';

void main() {
  bootstrap(() => const ExampleApp());
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
      title: 'Flutter Prakash Example',
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
