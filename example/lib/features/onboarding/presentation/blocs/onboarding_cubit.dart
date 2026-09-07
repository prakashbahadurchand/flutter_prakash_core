import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/blocs/onboarding_state.dart';

@injectable
class OnboardingCubit extends BaseCubit<OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingCubit(this._repository) : super(const OnboardingState());

  @postConstruct
  void init() {
    final slides = _repository.getSlides();
    safeEmit(state.copyWith(slides: slides));
  }

  void onPageChanged(int index) {
    if (state.currentIndex != index) {
      safeEmit(state.copyWith(currentIndex: index));
    }
  }

  Future<void> completeOnboarding() async {
    final result = await _repository.completeOnboarding();
    result.when(
      success: (_) {
        safeEmit(state.copyWith(isCompleted: true));
      },
      error: (_) {
        safeEmit(state.copyWith(isCompleted: true));
      },
    );
  }
}
