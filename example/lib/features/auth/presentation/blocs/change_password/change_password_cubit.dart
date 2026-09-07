import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/change_password/change_password_state.dart';

@injectable
class ChangePasswordCubit extends FormCubit<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordCubit(this._authRepository)
    : super(ChangePasswordState.initial());

  void onCurrentPasswordChanged(String value) =>
      emit(state.copyWith(currentPassword: state.currentPassword(value)));

  void onNewPasswordChanged(String value) =>
      emit(state.copyWith(newPassword: state.newPassword(value)));

  void onConfirmPasswordChanged(String value) =>
      emit(state.copyWith(confirmPassword: state.confirmPassword(value)));

  void toggleCurrentPasswordVisibility() => emit(
    state.copyWith(isCurrentPasswordObscured: !state.isCurrentPasswordObscured),
  );

  void toggleNewPasswordVisibility() =>
      emit(state.copyWith(isNewPasswordObscured: !state.isNewPasswordObscured));

  void toggleConfirmPasswordVisibility() => emit(
    state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured),
  );

  void reset() => emit(ChangePasswordState.initial());

  @override
  Future<Result<dynamic>> performSubmit() {
    if (state.newPassword.value != state.confirmPassword.value) {
      return Future.value(
        const Result.error(ValidationFailure('New passwords do not match')),
      );
    }
    if (state.newPassword.value == state.currentPassword.value) {
      return Future.value(
        const Result.error(
          ValidationFailure(
            'New password cannot be the same as current password',
          ),
        ),
      );
    }
    return _authRepository.changePassword(state.toDto());
  }
}
