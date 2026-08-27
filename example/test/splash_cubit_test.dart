import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core_example/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/splash/data/repositories/splash_repository.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/blocs/splash_cubit.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/blocs/splash_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SplashLocalDataSource localDataSource;
  late SplashRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    localDataSource = SplashLocalDataSource(prefs);
    repository = SplashRepository(localDataSource);
  });

  group('SplashCubit', () {
    test('initial state is SplashInitial', () {
      final cubit = SplashCubit(repository);
      expect(cubit.state, isA<SplashInitial>());
      cubit.close();
    });

    test('initialize loads initModel and emits SplashSuccess', () async {
      final cubit = SplashCubit(repository);
      await cubit.initialize();

      expect(cubit.state, isA<SplashSuccess>());
      final state = cubit.state as SplashSuccess;
      expect(state.initModel.isOnboardingCompleted, isFalse);
      expect(state.initModel.isAuthenticated, isFalse);
      cubit.close();
    });
  });
}
