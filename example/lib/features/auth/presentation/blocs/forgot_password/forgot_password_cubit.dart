import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends FormCubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository)
      : super(ForgotPasswordState.initial());

  void onEmailChanged(String value) =>
      emit(state.copyWith(email: state.email(value)));

  void reset() => emit(ForgotPasswordState.initial());

  @override
  Future<Result<dynamic>> performSubmit() {
    return _authRepository.forgotPassword(state.toDto());
  }
}
