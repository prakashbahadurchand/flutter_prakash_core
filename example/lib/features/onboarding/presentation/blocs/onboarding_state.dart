import 'package:flutter_prakash_core_example/features/onboarding/data/models/onboarding_item_model.dart';

class OnboardingState {
  final List<OnboardingItemModel> slides;
  final int currentIndex;
  final bool isCompleted;

  const OnboardingState({
    this.slides = const [],
    this.currentIndex = 0,
    this.isCompleted = false,
  });

  bool get isLastPage => slides.isNotEmpty && currentIndex == slides.length - 1;

  OnboardingState copyWith({
    List<OnboardingItemModel>? slides,
    int? currentIndex,
    bool? isCompleted,
  }) {
    return OnboardingState(
      slides: slides ?? this.slides,
      currentIndex: currentIndex ?? this.currentIndex,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
