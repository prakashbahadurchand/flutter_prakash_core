import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/register/register_state.dart';

@injectable
class RegisterCubit extends FormCubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(RegisterState.initial());

  void onFullNameChanged(String value) =>
      emit(state.copyWith(fullName: state.fullName(value)));

  void onEmailChanged(String value) =>
      emit(state.copyWith(email: state.email(value)));

  void onPasswordChanged(String value) {
    final updatedPass = state.password(value);
    emit(state.copyWith(password: updatedPass));
  }

  void onConfirmPasswordChanged(String value) {
    final updatedConfirm = state.confirmPassword(value);
    emit(state.copyWith(confirmPassword: updatedConfirm));
  }

  void onAgreeToTermsChanged(bool? value) =>
      emit(state.copyWith(agreeToTerms: state.agreeToTerms(value ?? false)));

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));

  void toggleConfirmPasswordVisibility() => emit(
    state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured),
  );

  void reset() => emit(RegisterState.initial());

  @override
  Future<Result<dynamic>> performSubmit() {
    if (state.password.value != state.confirmPassword.value) {
      return Future.value(
        const Result.error(ValidationFailure('Passwords do not match')),
      );
    }
    if (!state.agreeToTerms.value) {
      return Future.value(
        const Result.error(
          ValidationFailure('You must agree to the Terms and Privacy Policy'),
        ),
      );
    }
    return _authRepository.register(state.toDto());
  }
}
