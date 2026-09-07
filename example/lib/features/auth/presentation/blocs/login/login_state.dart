import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/login_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState, FormMixin implements FormState {
  const LoginState._();

  const factory LoginState({
    required Field<String> email,
    required Field<String> password,
    required Field<bool> rememberMe,
    @Default(true) bool isPasswordObscured,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _LoginState;

  factory LoginState.initial() => LoginState(
    email: Fields.email(labelText: 'Email Address'),
    password: Fields.password(minLength: 6),
    rememberMe: Fields.boolean(
      initialValue: false,
      labelText: 'Remember this device',
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

  LoginRequestModel toDto() => LoginRequestModel(
    email: email.value.trim(),
    password: password.value,
    rememberMe: rememberMe.value,
  );
}
