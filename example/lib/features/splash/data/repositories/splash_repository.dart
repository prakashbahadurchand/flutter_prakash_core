import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/splash/data/models/splash_init_model.dart';

@lazySingleton
class SplashRepository {
  final SplashLocalDataSource _localDataSource;

  const SplashRepository(this._localDataSource);

  FutureResult<SplashInitModel> initializeApp() {
    return Result.fromAsync(
      call: () => _localDataSource.checkAppInitialization(),
    );
  }
}
