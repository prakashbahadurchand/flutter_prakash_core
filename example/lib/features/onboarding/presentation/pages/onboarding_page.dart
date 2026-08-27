import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/core/router/app_router.dart';
import 'package:flutter_prakash_core_example/features/onboarding/data/models/onboarding_item_model.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/blocs/onboarding_cubit.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/blocs/onboarding_state.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/widgets/onboarding_dots_indicator.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/widgets/onboarding_slide_widget.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final OnboardingCubit _cubit;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OnboardingCubit>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onFinish() async {
    await _cubit.completeOnboarding();
    if (mounted) {
      context.router.replace(const LoginRoute());
    }
  }

  void _onNext() {
    if (_cubit.state.isLastPage) {
      _onFinish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocProvider.value(
        value: _cubit,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppPalette.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppConstants.appName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _onFinish,
                      style: TextButton.styleFrom(
                        foregroundColor: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocSelector<OnboardingCubit, OnboardingState,
                    List<OnboardingItemModel>>(
                  selector: (state) => state.slides,
                  builder: (context, slides) {
                    if (slides.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return PageView.builder(
                      controller: _pageController,
                      onPageChanged: _cubit.onPageChanged,
                      itemCount: slides.length,
                      itemBuilder: (context, index) {
                        return OnboardingSlideWidget(item: slides[index]);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocSelector<OnboardingCubit, OnboardingState, (int, int)>(
                      selector: (state) =>
                          (state.slides.length, state.currentIndex),
                      builder: (context, data) {
                        final (count, currentIndex) = data;
                        return OnboardingDotsIndicator(
                          count: count,
                          currentIndex: currentIndex,
                        );
                      },
                    ),
                    BlocSelector<OnboardingCubit, OnboardingState, bool>(
                      selector: (state) => state.isLastPage,
                      builder: (context, isLastPage) {
                        return ElevatedButton(
                          onPressed: _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPalette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isLastPage ? 'Get Started' : 'Next',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
