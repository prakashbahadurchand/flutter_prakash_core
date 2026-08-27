import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/change_password_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState, FormMixin implements FormState {
  const ChangePasswordState._();

  const factory ChangePasswordState({
    required Field<String> currentPassword,
    required Field<String> newPassword,
    required Field<String> confirmPassword,
    @Default(true) bool isCurrentPasswordObscured,
    @Default(true) bool isNewPasswordObscured,
    @Default(true) bool isConfirmPasswordObscured,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _ChangePasswordState;

  factory ChangePasswordState.initial() => ChangePasswordState(
        currentPassword: Field(
          labelText: 'Current Password',
          value: '',
          validators: Validators.required(),
        ),
        newPassword: Field(
          labelText: 'New Password',
          value: '',
          validators: Validators.required().minLength(6),
        ),
        confirmPassword: Field(
          labelText: 'Confirm New Password',
          value: '',
          validators: Validators.required(),
        ),
        isCurrentPasswordObscured: true,
        isNewPasswordObscured: true,
        isConfirmPasswordObscured: true,
      );

  @override
  List<Field<dynamic>> get formFields => [
        currentPassword,
        newPassword,
        confirmPassword,
      ];

  @override
  ChangePasswordState copyWithStatus(BlocStatus status) =>
      copyWith(status: status);

  @override
  ChangePasswordState makeAllDirty() => copyWith(
        currentPassword: currentPassword.makeDirty(),
        newPassword: newPassword.makeDirty(),
        confirmPassword: confirmPassword.makeDirty(),
      );

  ChangePasswordRequestModel toDto() => ChangePasswordRequestModel(
        currentPassword: currentPassword.value,
        newPassword: newPassword.value,
      );
}
