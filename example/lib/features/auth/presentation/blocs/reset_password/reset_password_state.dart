import 'package:flutter_prakash_core/flutter_prakash_core.dart';

class ResetPasswordState extends FormCubitState<bool> {
  final String email;
  final Field<String> otpCode;
  final Field<String> newPassword;
  final Field<String> confirmPassword;

  ResetPasswordState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    this.email = '',
    Field<String>? otpCode,
    Field<String>? newPassword,
    Field<String>? confirmPassword,
  })  : otpCode = otpCode ??
            Field(
              value: '',
              labelText: 'OTP Code',
              validators: Validators.required().exactLength(6),
            ),
        newPassword = newPassword ??
            Field(
              value: '',
              labelText: 'New Password',
              validators: Validators.required().minLength(6),
            ),
        confirmPassword = confirmPassword ??
            Field(
              value: '',
              labelText: 'Confirm Password',
              validators: Validators.required(),
            );

  @override
  ResetPasswordState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    bool? result,
    String? email,
    Field<String>? otpCode,
    Field<String>? newPassword,
    Field<String>? confirmPassword,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      email: email ?? this.email,
      otpCode: otpCode ?? this.otpCode,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    email,
    otpCode,
    newPassword,
    confirmPassword,
  ];
}
