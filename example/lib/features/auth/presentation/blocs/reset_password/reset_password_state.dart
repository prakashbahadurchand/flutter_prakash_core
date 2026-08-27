import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/reset_password_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

@freezed
abstract class ResetPasswordState with _$ResetPasswordState, FormMixin implements FormState {
  const ResetPasswordState._();

  const factory ResetPasswordState({
    required Field<String> otpCode,
    required Field<String> newPassword,
    required Field<String> confirmPassword,
    @Default('') String email,
    @Default(true) bool isNewPasswordObscured,
    @Default(true) bool isConfirmPasswordObscured,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _ResetPasswordState;

  factory ResetPasswordState.initial() => ResetPasswordState(
        otpCode: Field(
          labelText: '6-digit Reset Code',
          value: '',
          validators: Validators.required().exactLength(6),
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
        isNewPasswordObscured: true,
        isConfirmPasswordObscured: true,
      );

  @override
  List<Field<dynamic>> get formFields => [
        otpCode,
        newPassword,
        confirmPassword,
      ];

  @override
  ResetPasswordState copyWithStatus(BlocStatus status) =>
      copyWith(status: status);

  @override
  ResetPasswordState makeAllDirty() => copyWith(
        otpCode: otpCode.makeDirty(),
        newPassword: newPassword.makeDirty(),
        confirmPassword: confirmPassword.makeDirty(),
      );

  ResetPasswordRequestModel toDto() => ResetPasswordRequestModel(
        email: email.trim(),
        otpCode: otpCode.value.trim(),
        newPassword: newPassword.value,
      );
}
