import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/reset_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/reset_password/reset_password_state.dart';

@injectable
class ResetPasswordCubit extends BaseFormCubit<ResetPasswordState, bool> {
  final AuthRepository _repository;

  ResetPasswordCubit(this._repository) : super(ResetPasswordState());

  void init(String email, {String? defaultOtp}) {
    safeEmit(state.copyWith(
      email: email,
      otpCode: defaultOtp != null ? state.otpCode(defaultOtp) : state.otpCode,
    ));
  }

  void otpChanged(String value) {
    final field = state.otpCode(value);
    _validate(otpCode: field);
  }

  void newPasswordChanged(String value) {
    final field = state.newPassword(value);
    _validate(newPassword: field);
  }

  void confirmPasswordChanged(String value) {
    final field = state.confirmPassword(value);
    _validate(confirmPassword: field);
  }

  void _validate({
    Field<String>? otpCode,
    Field<String>? newPassword,
    Field<String>? confirmPassword,
  }) {
    final curOtp = otpCode ?? state.otpCode;
    final curNew = newPassword ?? state.newPassword;
    final curConfirm = confirmPassword ?? state.confirmPassword;

    final isMatch = curNew.value == curConfirm.value;
    final isValid = curOtp.isValid &&
        curNew.isValid &&
        curConfirm.isValid &&
        isMatch &&
        curOtp.value.length == 6;

    safeEmit(state.copyWith(
      otpCode: curOtp,
      newPassword: curNew,
      confirmPassword: curConfirm,
      isValid: isValid,
    ));
  }

  Future<void> resetPassword() async {
    await submitForm(
      call: () => _repository.resetPassword(
        ResetPasswordRequestModel(
          email: state.email,
          otpCode: state.otpCode.value,
          newPassword: state.newPassword.value,
        ),
      ),
      onSuccess: (_) {
        emitEffect(
          const ShowToastEffect(
            'Password has been reset successfully! Please log in.',
          ),
        );
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
