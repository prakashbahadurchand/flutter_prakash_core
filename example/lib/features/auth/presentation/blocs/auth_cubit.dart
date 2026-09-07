import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_state.dart';

@lazySingleton
class AuthCubit extends BaseCubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthInitial());

  @postConstruct
  void init() {
    checkAuthStatus();
  }

  void checkAuthStatus() {
    if (_repository.isAuthenticated) {
      final user = _repository.currentUser;
      if (user != null) {
        safeEmit(Authenticated(user));
        return;
      }
    }
    safeEmit(const Unauthenticated());
  }

  void setAuthenticatedUser(AuthUserModel user) {
    safeEmit(Authenticated(user));
  }

  Future<void> logout() async {
    safeEmit(const AuthLoading());
    await _repository.logout();
    safeEmit(const Unauthenticated());
    emitEffect(const ShowToastEffect('Logged out successfully.'));
  }
}
