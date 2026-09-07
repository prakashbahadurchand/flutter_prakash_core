import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/verify_email_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_state.freezed.dart';

@freezed
abstract class EmailVerificationState
    with _$EmailVerificationState, FormMixin
    implements FormState {
  const EmailVerificationState._();

  const factory EmailVerificationState({
    required Field<String> otpCode,
    @Default('') String email,
    @Default(60) int resendCountdown,
    @Default(false) bool canResend,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _EmailVerificationState;

  factory EmailVerificationState.initial() => EmailVerificationState(
    otpCode: Fields.otp(length: 6, labelText: 'Verification Code'),
  );

  @override
  List<Field<dynamic>> get formFields => [otpCode];

  @override
  EmailVerificationState copyWithStatus(BlocStatus status) =>
      copyWith(status: status);

  @override
  EmailVerificationState makeAllDirty() =>
      copyWith(otpCode: otpCode.makeDirty());

  VerifyEmailRequestModel toDto() => VerifyEmailRequestModel(
    email: email.trim(),
    otpCode: otpCode.value.trim(),
  );
}
