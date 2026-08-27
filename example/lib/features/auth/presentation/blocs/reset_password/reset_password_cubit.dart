import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/reset_password/reset_password_state.dart';

@injectable
class ResetPasswordCubit extends FormCubit<ResetPasswordState> {
  final AuthRepository _authRepository;

  ResetPasswordCubit(this._authRepository)
      : super(ResetPasswordState.initial());

  void init(String email, {String? defaultOtp}) {
    var initial = state.copyWith(email: email);
    if (defaultOtp != null && defaultOtp.isNotEmpty) {
      initial = initial.copyWith(otpCode: state.otpCode(defaultOtp));
    }
    emit(initial);
  }

  void onOtpChanged(String value) =>
      emit(state.copyWith(otpCode: state.otpCode(value)));

  void onNewPasswordChanged(String value) =>
      emit(state.copyWith(newPassword: state.newPassword(value)));

  void onConfirmPasswordChanged(String value) =>
      emit(state.copyWith(confirmPassword: state.confirmPassword(value)));

  void toggleNewPasswordVisibility() => emit(
        state.copyWith(isNewPasswordObscured: !state.isNewPasswordObscured),
      );

  void toggleConfirmPasswordVisibility() => emit(
        state.copyWith(
          isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
        ),
      );

  void reset() => emit(ResetPasswordState.initial());

  @override
  Future<Result<dynamic>> performSubmit() {
    if (state.newPassword.value != state.confirmPassword.value) {
      return Future.value(
        const Result.error(
          ValidationFailure('Passwords do not match'),
        ),
      );
    }
    return _authRepository.resetPassword(state.toDto());
  }
}
