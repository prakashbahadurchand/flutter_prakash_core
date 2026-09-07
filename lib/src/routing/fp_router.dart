import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../loggers/flutter_logger.dart';

/// Base abstract route guard for `AutoRoute`.
///
/// Simplifies implementing authentication guards, role guards, or feature-flag route guards.
abstract class FpRouteGuard extends AutoRouteGuard {
  const FpRouteGuard();

  /// Abstract method to perform authorization logic synchronously or asynchronously.
  Future<bool> canNavigate(NavigationResolver resolver);

  /// Callback executed when access is denied. Override to redirect to login/unauthorized screen.
  void onUnauthorized(NavigationResolver resolver, StackRouter router) {
    resolver.next(false);
  }

  /// Intercepts navigation to check permissions via [canNavigate] and delegates to [onUnauthorized] if access is denied.
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final allowed = await canNavigate(resolver);
    if (allowed) {
      resolver.next(true);
    } else {
      FlutterLogger.w('Navigation denied for route: ${resolver.route.name}');
      onUnauthorized(resolver, router);
    }
  }
}

/// Global route navigation observer for tracking active screens and logging navigation events.
class FpRouteObserver extends AutoRouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    FlutterLogger.i(
      '[Route Pushed] ${route.settings.name} (from ${previousRoute?.settings.name})',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    FlutterLogger.i(
      '[Route Popped] ${route.settings.name} (to ${previousRoute?.settings.name})',
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    FlutterLogger.i(
      '[Route Replaced] ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
    );
  }
}
