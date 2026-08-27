import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/forgot_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends BaseFormCubit<ForgotPasswordState, String> {
  final AuthRepository _repository;

  ForgotPasswordCubit(this._repository) : super(ForgotPasswordState());

  void emailChanged(String value) {
    final field = state.email(value);
    safeEmit(state.copyWith(
      email: field,
      isValid: field.isValid,
    ));
  }

  Future<void> sendResetCode() async {
    await submitForm(
      call: () => _repository.forgotPassword(
        ForgotPasswordRequestModel(email: state.email.value),
      ),
      onSuccess: (message) {
        emitEffect(ShowToastEffect(message));
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
