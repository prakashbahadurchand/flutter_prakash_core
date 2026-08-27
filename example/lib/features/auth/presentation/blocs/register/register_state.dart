import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/register_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState
    with _$RegisterState, FormMixin
    implements FormState {
  const RegisterState._();

  const factory RegisterState({
    required Field<String> fullName,
    required Field<String> email,
    required Field<String> password,
    required Field<String> confirmPassword,
    required Field<bool> agreeToTerms,
    @Default(true) bool isPasswordObscured,
    @Default(true) bool isConfirmPasswordObscured,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
    fullName: Field(
      labelText: 'Full Name',
      value: '',
      validators: Validators.required().minLength(2),
    ),
    email: Field(
      labelText: 'Email Address',
      value: '',
      validators: Validators.required().email(),
    ),
    password: Field(
      labelText: 'Password',
      value: '',
      validators: Validators.required().minLength(6),
    ),
    confirmPassword: Field(
      labelText: 'Confirm Password',
      value: '',
      validators: Validators.required(),
    ),
    agreeToTerms: const Field(
      labelText: 'Agree to Terms and Privacy Policy',
      value: false,
      validators: [],
    ),
    isPasswordObscured: true,
    isConfirmPasswordObscured: true,
  );

  @override
  List<Field<dynamic>> get formFields => [
    fullName,
    email,
    password,
    confirmPassword,
  ];

  @override
  RegisterState copyWithStatus(BlocStatus status) => copyWith(status: status);

  @override
  RegisterState makeAllDirty() => copyWith(
    fullName: fullName.makeDirty(),
    email: email.makeDirty(),
    password: password.makeDirty(),
    confirmPassword: confirmPassword.makeDirty(),
  );

  RegisterRequestModel toDto() => RegisterRequestModel(
    fullName: fullName.value.trim(),
    email: email.value.trim(),
    password: password.value,
    agreeToTerms: agreeToTerms.value,
  );
}
