import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/core/router/app_router.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/blocs/splash_cubit.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/blocs/splash_state.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/widgets/splash_brand_logo.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/widgets/splash_loading_bar.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SplashCubit>()..initialize(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStateChange(BuildContext context, SplashState state) {
    if (state is SplashSuccess) {
      if (state.initModel.isAuthenticated) {
        context.router.replace(const DashboardRoute());
      } else if (state.initModel.isOnboardingCompleted) {
        context.router.replace(const LoginRoute());
      } else {
        context.router.replace(const OnboardingRoute());
      }
    } else if (state is SplashFailure) {
      Toast.error(state.message);
      context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: _onStateChange,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppPalette.slate900,
                      AppPalette.slate800,
                      AppPalette.slate900,
                    ]
                  : [
                      AppPalette.primaryBgLight,
                      AppPalette.primaryBgHover,
                      AppPalette.primaryLight,
                    ],
            ),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SplashBrandLogo(),
                        SizedBox(height: 48),
                        SplashLoadingBar(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
