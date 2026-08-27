import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/change_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/change_password/change_password_state.dart';

@injectable
class ChangePasswordCubit extends BaseFormCubit<ChangePasswordState, bool> {
  final AuthRepository _repository;

  ChangePasswordCubit(this._repository) : super(ChangePasswordState());

  void currentPasswordChanged(String value) {
    final field = state.currentPassword(value);
    _validate(currentPassword: field);
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
    Field<String>? currentPassword,
    Field<String>? newPassword,
    Field<String>? confirmPassword,
  }) {
    final curCurrent = currentPassword ?? state.currentPassword;
    final curNew = newPassword ?? state.newPassword;
    final curConfirm = confirmPassword ?? state.confirmPassword;

    final isMatch = curNew.value == curConfirm.value;
    final isValid = curCurrent.isValid &&
        curNew.isValid &&
        curConfirm.isValid &&
        isMatch &&
        curNew.value != curCurrent.value;

    safeEmit(state.copyWith(
      currentPassword: curCurrent,
      newPassword: curNew,
      confirmPassword: curConfirm,
      isValid: isValid,
    ));
  }

  Future<void> changePassword() async {
    await submitForm(
      call: () => _repository.changePassword(
        ChangePasswordRequestModel(
          currentPassword: state.currentPassword.value,
          newPassword: state.newPassword.value,
        ),
      ),
      onSuccess: (_) {
        emitEffect(
          const ShowToastEffect('Password changed successfully!'),
        );
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
