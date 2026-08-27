import 'package:flutter_prakash_core/flutter_prakash_core.dart';

class EmailVerificationState extends FormCubitState<bool> {
  final String email;
  final Field<String> otpCode;
  final int resendCountdown;
  final bool canResend;

  EmailVerificationState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    this.email = '',
    Field<String>? otpCode,
    this.resendCountdown = 60,
    this.canResend = false,
  }) : otpCode = otpCode ??
            Field(
              value: '',
              labelText: '6-digit OTP Code',
              validators: Validators.required().exactLength(6),
            );

  @override
  EmailVerificationState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    bool? result,
    String? email,
    Field<String>? otpCode,
    int? resendCountdown,
    bool? canResend,
  }) {
    return EmailVerificationState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      email: email ?? this.email,
      otpCode: otpCode ?? this.otpCode,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      canResend: canResend ?? this.canResend,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    email,
    otpCode,
    resendCountdown,
    canResend,
  ];
}
