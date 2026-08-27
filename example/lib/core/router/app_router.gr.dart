// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AdMobShowcasePage]
class AdMobShowcaseRoute extends PageRouteInfo<void> {
  const AdMobShowcaseRoute({List<PageRouteInfo>? children})
    : super(AdMobShowcaseRoute.name, initialChildren: children);

  static const String name = 'AdMobShowcaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdMobShowcasePage();
    },
  );
}

/// generated route for
/// [ChangePasswordPage]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordPage();
    },
  );
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardPage();
    },
  );
}

/// generated route for
/// [EmailVerificationPage]
class EmailVerificationRoute extends PageRouteInfo<EmailVerificationRouteArgs> {
  EmailVerificationRoute({
    Key? key,
    required String email,
    List<PageRouteInfo>? children,
  }) : super(
         EmailVerificationRoute.name,
         args: EmailVerificationRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'EmailVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmailVerificationRouteArgs>();
      return EmailVerificationPage(key: args.key, email: args.email);
    },
  );
}

class EmailVerificationRouteArgs {
  const EmailVerificationRouteArgs({this.key, required this.email});

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'EmailVerificationRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [FilePreviewPage]
class FilePreviewRoute extends PageRouteInfo<FilePreviewRouteArgs> {
  FilePreviewRoute({
    Key? key,
    required String filePath,
    required FileType fileType,
    FileSourceType sourceType = FileSourceType.network,
    String? title,
    List<PageRouteInfo>? children,
  }) : super(
         FilePreviewRoute.name,
         args: FilePreviewRouteArgs(
           key: key,
           filePath: filePath,
           fileType: fileType,
           sourceType: sourceType,
           title: title,
         ),
         initialChildren: children,
       );

  static const String name = 'FilePreviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FilePreviewRouteArgs>();
      return FilePreviewPage(
        key: args.key,
        filePath: args.filePath,
        fileType: args.fileType,
        sourceType: args.sourceType,
        title: args.title,
      );
    },
  );
}

class FilePreviewRouteArgs {
  const FilePreviewRouteArgs({
    this.key,
    required this.filePath,
    required this.fileType,
    this.sourceType = FileSourceType.network,
    this.title,
  });

  final Key? key;

  final String filePath;

  final FileType fileType;

  final FileSourceType sourceType;

  final String? title;

  @override
  String toString() {
    return 'FilePreviewRouteArgs{key: $key, filePath: $filePath, fileType: $fileType, sourceType: $sourceType, title: $title}';
  }
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [InAppWebViewPage]
class InAppWebViewRoute extends PageRouteInfo<InAppWebViewRouteArgs> {
  InAppWebViewRoute({
    Key? key,
    required String initialUrl,
    String? title,
    List<PageRouteInfo>? children,
  }) : super(
         InAppWebViewRoute.name,
         args: InAppWebViewRouteArgs(
           key: key,
           initialUrl: initialUrl,
           title: title,
         ),
         initialChildren: children,
       );

  static const String name = 'InAppWebViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InAppWebViewRouteArgs>();
      return InAppWebViewPage(
        key: args.key,
        initialUrl: args.initialUrl,
        title: args.title,
      );
    },
  );
}

class InAppWebViewRouteArgs {
  const InAppWebViewRouteArgs({this.key, required this.initialUrl, this.title});

  final Key? key;

  final String initialUrl;

  final String? title;

  @override
  String toString() {
    return 'InAppWebViewRouteArgs{key: $key, initialUrl: $initialUrl, title: $title}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPage();
    },
  );
}

/// generated route for
/// [PrivacyPolicyPage]
class PrivacyPolicyRoute extends PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacyPolicyPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [ReportFeedbackPage]
class ReportFeedbackRoute extends PageRouteInfo<void> {
  const ReportFeedbackRoute({List<PageRouteInfo>? children})
    : super(ReportFeedbackRoute.name, initialChildren: children);

  static const String name = 'ReportFeedbackRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReportFeedbackPage();
    },
  );
}

/// generated route for
/// [ResetPasswordPage]
class ResetPasswordRoute extends PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    Key? key,
    required String email,
    String? otp,
    List<PageRouteInfo>? children,
  }) : super(
         ResetPasswordRoute.name,
         args: ResetPasswordRouteArgs(key: key, email: email, otp: otp),
         initialChildren: children,
       );

  static const String name = 'ResetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordRouteArgs>();
      return ResetPasswordPage(key: args.key, email: args.email, otp: args.otp);
    },
  );
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({this.key, required this.email, this.otp});

  final Key? key;

  final String email;

  final String? otp;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key, email: $email, otp: $otp}';
  }
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TermsAndConditionsPage]
class TermsAndConditionsRoute extends PageRouteInfo<void> {
  const TermsAndConditionsRoute({List<PageRouteInfo>? children})
    : super(TermsAndConditionsRoute.name, initialChildren: children);

  static const String name = 'TermsAndConditionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TermsAndConditionsPage();
    },
  );
}
