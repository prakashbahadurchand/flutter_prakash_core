import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core_example/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/change_password/change_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/email_verification/email_verification_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/login/login_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/register/register_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/reset_password/reset_password_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AuthLocalDataSource localDataSource;
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepository authRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    localDataSource = AuthLocalDataSource(prefs);
    remoteDataSource = AuthRemoteDataSource();
    authRepository = AuthRepository(localDataSource, remoteDataSource);
  });

  group('LoginCubit', () {
    test('initial state is valid initial form', () {
      final cubit = LoginCubit(authRepository);
      expect(cubit.state.email.value, isEmpty);
      expect(cubit.state.password.value, isEmpty);
      expect(cubit.state.rememberMe.value, isFalse);
      expect(cubit.state.isPasswordObscured, isTrue);
      expect(cubit.state.status.isInitial, isTrue);
      cubit.close();
    });

    test('updates email and password properly', () {
      final cubit = LoginCubit(authRepository);
      cubit.onEmailChanged('test@example.com');
      cubit.onPasswordChanged('password123');
      cubit.onRememberMeChanged(true);
      cubit.togglePasswordVisibility();

      expect(cubit.state.email.value, 'test@example.com');
      expect(cubit.state.email.isValid, isTrue);
      expect(cubit.state.password.value, 'password123');
      expect(cubit.state.rememberMe.value, isTrue);
      expect(cubit.state.isPasswordObscured, isFalse);
      cubit.close();
    });

    test('submit succeeds with valid credentials', () async {
      final cubit = LoginCubit(authRepository);
      cubit.onEmailChanged('demo@example.com');
      cubit.onPasswordChanged('secret123');

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });

  group('RegisterCubit', () {
    test('submit fails when passwords do not match', () async {
      final cubit = RegisterCubit(authRepository);
      cubit.onFullNameChanged('John Doe');
      cubit.onEmailChanged('john@example.com');
      cubit.onPasswordChanged('password123');
      cubit.onConfirmPasswordChanged('different_password');
      cubit.onAgreeToTermsChanged(true);

      await cubit.submit();

      expect(cubit.state.status.isFailure, isTrue);
      cubit.close();
    });

    test('submit succeeds when input is valid', () async {
      final cubit = RegisterCubit(authRepository);
      cubit.onFullNameChanged('John Doe');
      cubit.onEmailChanged('john@example.com');
      cubit.onPasswordChanged('password123');
      cubit.onConfirmPasswordChanged('password123');
      cubit.onAgreeToTermsChanged(true);

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });

  group('ForgotPasswordCubit', () {
    test('submit triggers reset email dispatch', () async {
      final cubit = ForgotPasswordCubit(authRepository);
      cubit.onEmailChanged('user@example.com');

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });

  group('EmailVerificationCubit', () {
    test('submits valid 6 digit OTP', () async {
      final cubit = EmailVerificationCubit(authRepository);
      cubit.init('user@example.com');
      cubit.onOtpChanged('123456');

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });

  group('ResetPasswordCubit', () {
    test('resets password when fields are valid and match', () async {
      final cubit = ResetPasswordCubit(authRepository);
      cubit.init('user@example.com', defaultOtp: '123456');
      cubit.onNewPasswordChanged('newPassword123');
      cubit.onConfirmPasswordChanged('newPassword123');

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });

  group('ChangePasswordCubit', () {
    test('fails when new password equals current password', () async {
      final cubit = ChangePasswordCubit(authRepository);
      cubit.onCurrentPasswordChanged('oldPassword123');
      cubit.onNewPasswordChanged('oldPassword123');
      cubit.onConfirmPasswordChanged('oldPassword123');

      await cubit.submit();

      expect(cubit.state.status.isFailure, isTrue);
      cubit.close();
    });

    test('succeeds when new password is valid and different', () async {
      final cubit = ChangePasswordCubit(authRepository);
      cubit.onCurrentPasswordChanged('oldPassword123');
      cubit.onNewPasswordChanged('brandNewPassword123');
      cubit.onConfirmPasswordChanged('brandNewPassword123');

      await cubit.submit();

      expect(cubit.state.status.isSuccess, isTrue);
      cubit.close();
    });
  });

  group('AuthCubit', () {
    test('checkAuthStatus sets unauthenticated when empty', () {
      final cubit = AuthCubit(authRepository);
      cubit.checkAuthStatus();

      expect(cubit.state, isA<Unauthenticated>());
      cubit.close();
    });

    test('setAuthenticatedUser sets user state', () {
      final cubit = AuthCubit(authRepository);
      final user = AuthUserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.now(),
      );
      cubit.setAuthenticatedUser(user);

      expect(cubit.state, isA<Authenticated>());
      final authState = cubit.state as Authenticated;
      expect(authState.user.email, 'test@example.com');
      cubit.close();
    });
  });
}
