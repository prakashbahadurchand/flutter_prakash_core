import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_prakash_example/src/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
