import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/register_request_dto.dart';

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
    required Field<String> role,
    required Field<bool> acceptTerms,
    @Default(true) bool isPasswordObscured,
    @Default(true) bool isConfirmPasswordObscured,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _RegisterState;

  factory RegisterState.initial() => RegisterState(
    fullName: Field(
      labelText: 'Full name',
      value: '',
      validators: Validators.required().minLength(2),
    ),
    email: Field(
      labelText: 'Corporate email',
      value: '',
      validators: Validators.required().email(),
    ),
    password: Field(
      labelText: 'Password',
      value: '',
      validators: Validators.required().minLength(8),
    ),
    confirmPassword: Field(
      labelText: 'Confirm password',
      value: '',
      validators: Validators.required(),
    ),
    role: const Field(
      labelText: 'Primary role',
      value: 'Engineer',
      validators: [],
    ),
    acceptTerms: Field(
      labelText: 'Terms of service',
      value: false,
      validators: Validators.mustBeTrue(),
    ),
  );

  @override
  List<Field<dynamic>> get formFields => [
    fullName,
    email,
    password,
    confirmPassword,
    role,
    acceptTerms,
  ];

  @override
  RegisterState copyWithStatus(BlocStatus status) => copyWith(status: status);

  @override
  RegisterState makeAllDirty() => copyWith(
    fullName: fullName.makeDirty(),
    email: email.makeDirty(),
    password: password.makeDirty(),
    confirmPassword: confirmPassword.makeDirty(),
    acceptTerms: acceptTerms.makeDirty(),
  );

  RegisterRequestDto toDto() => RegisterRequestDto(
    fullName: fullName.value.trim(),
    email: email.value.trim(),
    password: password.value,
    role: role.value,
    acceptTerms: acceptTerms.value,
  );
}
