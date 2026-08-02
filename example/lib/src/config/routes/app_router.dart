import 'package:auto_route/auto_route.dart';
import 'package:flutter_prakash_example/src/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_prakash_example/src/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_prakash_example/src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_prakash_example/src/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_prakash_example/src/features/splash/presentation/pages/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: DashboardRoute.page),
      ];
}
