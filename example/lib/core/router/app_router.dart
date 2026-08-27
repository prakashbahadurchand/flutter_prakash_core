import 'package:auto_route/auto_route.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/guards/auth_guard.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/pages/report_feedback_page.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/pages/terms_conditions_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(
      page: DashboardRoute.page,
      guards: [const ExampleAuthGuard(isAuthenticated: true)],
    ),
    AutoRoute(page: PrivacyPolicyRoute.page),
    AutoRoute(page: TermsConditionsRoute.page),
    AutoRoute(page: ReportFeedbackRoute.page),
  ];
}
