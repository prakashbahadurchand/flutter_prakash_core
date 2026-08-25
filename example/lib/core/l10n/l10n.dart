import 'package:flutter/widgets.dart';
import '../di/injection.dart';
import '../router/app_router.dart';
import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Top-level getter to access [AppLocalizations] globally without passing [BuildContext].
/// Uses the active navigator context from [AppRouter] via [GetIt].
///
/// ### Example Usage:
/// ```dart
/// final text = l10n.appTitle;
/// final welcome = l10n.welcomeUser('Alex');
/// ```
AppLocalizations get l10n {
  final context = getIt<AppRouter>().navigatorKey.currentContext;
  if (context == null) {
    throw StateError(
      'Cannot access global l10n: AppRouter navigatorKey.currentContext is null. '
      'Ensure the router is mounted in MaterialApp.',
    );
  }
  return AppLocalizations.of(context);
}

/// Ergonomic convenience extension on [BuildContext].
///
/// ### Example Usage:
/// ```dart
/// Text(context.l10n.login)
/// ```
extension L10nContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
