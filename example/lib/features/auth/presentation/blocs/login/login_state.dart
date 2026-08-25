import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/features/auth/data/models/login_request_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState, FormMixin implements FormState {
  const LoginState._();

  const factory LoginState({
    required Field<String> email,
    required Field<String> password,
    required Field<bool> rememberMe,
    @Default(false) bool isPasswordObscured,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _LoginState;

  factory LoginState.initial() => LoginState(
    email: Field(
      labelText: 'Corporate email',
      value: '',
      validators: Validators.required().email(),
    ),
    password: Field(
      labelText: 'Password',
      value: '',
      validators: Validators.required().minLength(6),
    ),
    rememberMe: const Field(
      labelText: 'Remember this device',
      value: false,
      validators: [],
    ),
    isPasswordObscured: true,
  );

  @override
  List<Field<dynamic>> get formFields => [email, password, rememberMe];

  @override
  LoginState copyWithStatus(BlocStatus status) => copyWith(status: status);

  @override
  LoginState makeAllDirty() =>
      copyWith(email: email.makeDirty(), password: password.makeDirty());

  LoginRequestDto toDto() => LoginRequestDto(
    email: email.value.trim(),
    password: password.value,
    rememberMe: rememberMe.value,
  );
}
