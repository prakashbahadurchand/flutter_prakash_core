import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/blocs/onboarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OnboardingLocalDataSource localDataSource;
  late OnboardingRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    localDataSource = OnboardingLocalDataSource(prefs);
    repository = OnboardingRepository(localDataSource);
  });

  group('OnboardingCubit', () {
    test('initial state and slide changes', () {
      final cubit = OnboardingCubit(repository)..init();
      expect(cubit.state.slides.isNotEmpty, isTrue);
      expect(cubit.state.currentIndex, 0);

      cubit.onPageChanged(1);
      expect(cubit.state.currentIndex, 1);
      cubit.close();
    });

    test('completeOnboarding sets isCompleted to true', () async {
      final cubit = OnboardingCubit(repository)..init();
      await cubit.completeOnboarding();

      expect(cubit.state.isCompleted, isTrue);
      cubit.close();
    });
  });
}
