import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/login/login_state.dart';

@injectable
class LoginCubit extends FormCubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  void onEmailChanged(String value) =>
      emit(state.copyWith(email: state.email(value)));

  void onPasswordChanged(String value) =>
      emit(state.copyWith(password: state.password(value)));

  void onRememberMeChanged(bool? value) =>
      emit(state.copyWith(rememberMe: state.rememberMe(value ?? false)));

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));

  void reset() => emit(LoginState.initial());

  @override
  Future<Result<dynamic>> performSubmit() {
    return _authRepository.login(state.toDto());
  }
}
