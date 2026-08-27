import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/login_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/login/login_state.dart';

@injectable
class LoginCubit extends BaseFormCubit<LoginState, AuthUserModel> {
  final AuthRepository _repository;
  final AuthCubit _authCubit;

  LoginCubit(this._repository, this._authCubit) : super(LoginState());

  void emailChanged(String value) {
    final field = state.email(value);
    safeEmit(state.copyWith(
      email: field,
      isValid: field.isValid && state.password.isValid,
    ));
  }

  void passwordChanged(String value) {
    final field = state.password(value);
    safeEmit(state.copyWith(
      password: field,
      isValid: state.email.isValid && field.isValid,
    ));
  }

  void rememberMeChanged(bool value) {
    safeEmit(state.copyWith(rememberMe: value));
  }

  Future<void> login() async {
    await submitForm(
      call: () => _repository.login(
        LoginRequestModel(
          email: state.email.value,
          password: state.password.value,
          rememberMe: state.rememberMe,
        ),
      ),
      onSuccess: (user) {
        _authCubit.setAuthenticatedUser(user);
        emitEffect(ShowToastEffect('Welcome back, ${user.name}!'));
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
