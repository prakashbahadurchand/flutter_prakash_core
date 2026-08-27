import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/register_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/register/register_state.dart';

@injectable
class RegisterCubit extends BaseFormCubit<RegisterState, AuthUserModel> {
  final AuthRepository _repository;
  final AuthCubit _authCubit;

  RegisterCubit(this._repository, this._authCubit) : super(RegisterState());

  void fullNameChanged(String value) {
    final field = state.fullName(value);
    _validateState(fullName: field);
  }

  void emailChanged(String value) {
    final field = state.email(value);
    _validateState(email: field);
  }

  void passwordChanged(String value) {
    final field = state.password(value);
    _validateState(password: field);
  }

  void confirmPasswordChanged(String value) {
    final field = state.confirmPassword(value);
    _validateState(confirmPassword: field);
  }

  void agreeToTermsChanged(bool value) {
    _validateState(agreeToTerms: value);
  }

  void _validateState({
    Field<String>? fullName,
    Field<String>? email,
    Field<String>? password,
    Field<String>? confirmPassword,
    bool? agreeToTerms,
  }) {
    final curFullName = fullName ?? state.fullName;
    final curEmail = email ?? state.email;
    final curPassword = password ?? state.password;
    final curConfirmPassword = confirmPassword ?? state.confirmPassword;
    final curAgree = agreeToTerms ?? state.agreeToTerms;

    final isMatch = curPassword.value == curConfirmPassword.value;
    final isValid = curFullName.isValid &&
        curEmail.isValid &&
        curPassword.isValid &&
        curConfirmPassword.isValid &&
        isMatch &&
        curAgree;

    safeEmit(state.copyWith(
      fullName: curFullName,
      email: curEmail,
      password: curPassword,
      confirmPassword: curConfirmPassword,
      agreeToTerms: curAgree,
      isValid: isValid,
    ));
  }

  Future<void> register() async {
    await submitForm(
      call: () => _repository.register(
        RegisterRequestModel(
          fullName: state.fullName.value,
          email: state.email.value,
          password: state.password.value,
          agreeToTerms: state.agreeToTerms,
        ),
      ),
      onSuccess: (user) {
        _authCubit.setAuthenticatedUser(user);
        emitEffect(
          ShowToastEffect('Account created successfully, ${user.name}!'),
        );
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
