import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/core/router/app_router.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';

/// Example authentication route guard demonstrating [PrakashRouteGuard].
class ExampleAuthGuard extends PrakashRouteGuard {
  final bool isAuthenticated;

  const ExampleAuthGuard({this.isAuthenticated = true});

  @override
  Future<bool> canNavigate(NavigationResolver resolver) async {
    // In production apps, inspect auth state or session token from repository/storage
    if (!isAuthenticated) return false;

    // Check DI if configured
    try {
      final authRepo = getIt<AuthRepository>();
      return authRepo.isAuthenticated;
    } catch (_) {
      return true;
    }
  }

  @override
  void onUnauthorized(NavigationResolver resolver) {
    // Redirect unauthorized users to Login screen
    resolver.redirect(const LoginRoute());
  }
}
