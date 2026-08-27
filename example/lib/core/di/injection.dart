import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_prakash_core_example/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true, asExtension: true)
Future<void> configureDependencies({String? environment}) async =>
    getIt.init(environment: environment);
