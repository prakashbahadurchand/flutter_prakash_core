import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/config/routes/app_router.dart';

/// Example authentication route guard demonstrating [PrakashRouteGuard].
class ExampleAuthGuard extends PrakashRouteGuard {
  final bool isAuthenticated;

  const ExampleAuthGuard({this.isAuthenticated = true});

  @override
  Future<bool> canNavigate(NavigationResolver resolver) async {
    // In production apps, inspect auth state or session token from AuthRepository/Storage
    return isAuthenticated;
  }

  @override
  void onUnauthorized(NavigationResolver resolver) {
    // Redirect unauthorized users to Login screen
    resolver.redirect(const LoginRoute());
  }
}
