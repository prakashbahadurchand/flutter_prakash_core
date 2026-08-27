import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart'
    hide FilePreviewPage, InAppWebViewPage;
import 'package:flutter_prakash_core_example/core/router/guards/auth_guard.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/change_password_page.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/email_verification_page.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/pages/file_preview/file_preview_page.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/pages/inapp_webview/inapp_webview_page.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/pages/privacy_policy/privacy_policy_page.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/pages/terms_and_conditions/terms_and_conditions_page.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/pages/admob_showcase_page.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_prakash_core_example/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/pages/report_feedback_page.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/pages/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: EmailVerificationRoute.page),
    AutoRoute(page: ResetPasswordRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),
    AutoRoute(
      page: DashboardRoute.page,
      guards: [const ExampleAuthGuard(isAuthenticated: true)],
    ),
    AutoRoute(page: AdMobShowcaseRoute.page),
    AutoRoute(page: ReportFeedbackRoute.page),
    AutoRoute(page: FilePreviewRoute.page),
    AutoRoute(page: InAppWebViewRoute.page),
    AutoRoute(page: PrivacyPolicyRoute.page),
    AutoRoute(page: TermsAndConditionsRoute.page),
  ];
}
