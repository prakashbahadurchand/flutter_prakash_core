import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import '../../../data/repositories/auth_repository.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends FormCubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(RegisterState.initial());

  void onFullNameChanged(String value) =>
      emit(state.copyWith(fullName: state.fullName(value)));

  void onEmailChanged(String value) =>
      emit(state.copyWith(email: state.email(value)));

  void onPasswordChanged(String value) {
    emit(
      state.copyWith(
        password: state.password(value),
        confirmPassword: state.confirmPassword.copyWith(
          validators: _confirmPasswordValidators(value),
        ),
      ),
    );
  }

  void onConfirmPasswordChanged(String value) {
    emit(
      state.copyWith(
        confirmPassword: state
            .confirmPassword(value)
            .copyWith(
              validators: _confirmPasswordValidators(state.password.value),
            ),
      ),
    );
  }

  void onRoleChanged(String value) =>
      emit(state.copyWith(role: state.role(value)));

  void onAcceptTermsChanged(bool? value) =>
      emit(state.copyWith(acceptTerms: state.acceptTerms(value ?? false)));

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));

  void toggleConfirmPasswordVisibility() => emit(
    state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured),
  );

  void reset() => emit(RegisterState.initial());

  ValidatorChain _confirmPasswordValidators(String password) =>
      Validators.required().match(
        () => password,
        'Passwords do not match',
        'Password',
      );

  @override
  Future<Result<dynamic>> performSubmit() {
    return _authRepository.register(state.toDto());
  }
}
