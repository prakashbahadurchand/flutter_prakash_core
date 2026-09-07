import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/change_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/forgot_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/login_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/register_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/reset_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/verify_email_request_model.dart';

@lazySingleton
class AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepository(this._localDataSource, this._remoteDataSource);

  bool get isAuthenticated => _localDataSource.hasValidSession();

  AuthUserModel? get currentUser => _localDataSource.getCachedUser();

  FutureResult<AuthUserModel> login(LoginRequestModel request) {
    return Result.fromAsync(
      call: () async {
        final result = await _remoteDataSource.login(request);
        await _localDataSource.saveSession(
          token: result.token,
          user: result.user,
        );
        return result.user;
      },
    );
  }

  FutureResult<AuthUserModel> register(RegisterRequestModel request) {
    return Result.fromAsync(
      call: () async {
        final result = await _remoteDataSource.register(request);
        await _localDataSource.saveSession(
          token: result.token,
          user: result.user,
        );
        return result.user;
      },
    );
  }

  FutureResult<String> forgotPassword(ForgotPasswordRequestModel request) {
    return Result.fromAsync(
      call: () => _remoteDataSource.forgotPassword(request),
    );
  }

  FutureResult<bool> verifyEmail(VerifyEmailRequestModel request) {
    return Result.fromAsync(call: () => _remoteDataSource.verifyEmail(request));
  }

  FutureResult<bool> resetPassword(ResetPasswordRequestModel request) {
    return Result.fromAsync(
      call: () => _remoteDataSource.resetPassword(request),
    );
  }

  FutureResult<bool> changePassword(ChangePasswordRequestModel request) {
    return Result.fromAsync(
      call: () => _remoteDataSource.changePassword(request),
    );
  }

  FutureResult<void> logout() {
    return Result.fromAsync(call: () => _localDataSource.clearSession());
  }
}
