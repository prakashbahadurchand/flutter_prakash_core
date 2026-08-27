import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/models/onboarding_item_model.dart';

@lazySingleton
class OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  const OnboardingRepository(this._localDataSource);

  List<OnboardingItemModel> getSlides() {
    return _localDataSource.getOnboardingSlides();
  }

  FutureResult<bool> completeOnboarding() {
    return Result.fromAsync(
      call: () => _localDataSource.setOnboardingCompleted(),
    );
  }
}
