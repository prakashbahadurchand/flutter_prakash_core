import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_token_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/change_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/forgot_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/login_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/register_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/reset_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/verify_email_request_model.dart';

@lazySingleton
class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<({AuthUserModel user, AuthTokenModel token})> login(
    LoginRequestModel request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final user = AuthUserModel(
      id: 'usr_prakash_99',
      email: request.email,
      name: request.email.split('@').first.toUpperCase(),
      avatarUrl: 'https://i.pravatar.cc/150?u=prakash',
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );

    final token = AuthTokenModel(
      accessToken: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'jwt_refresh_mock_${DateTime.now().millisecondsSinceEpoch}',
    );

    return (user: user, token: token);
  }

  Future<({AuthUserModel user, AuthTokenModel token})> register(
    RegisterRequestModel request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final user = AuthUserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: request.email,
      name: request.fullName,
      avatarUrl: 'https://i.pravatar.cc/150?u=new_user',
      isEmailVerified: false,
      createdAt: DateTime.now(),
    );

    final token = AuthTokenModel(
      accessToken: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'jwt_refresh_mock_${DateTime.now().millisecondsSinceEpoch}',
    );

    return (user: user, token: token);
  }

  Future<String> forgotPassword(ForgotPasswordRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'Verification code sent to ${request.email}';
  }

  Future<bool> verifyEmail(VerifyEmailRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (request.otpCode.length != 6) {
      throw const ValidationException(
        message: 'Invalid OTP code. Must be 6 digits.',
      );
    }
    return true;
  }

  Future<bool> resetPassword(ResetPasswordRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (request.otpCode.length != 6) {
      throw const ValidationException(
        message: 'Invalid OTP code. Must be 6 digits.',
      );
    }
    return true;
  }

  Future<bool> changePassword(ChangePasswordRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
