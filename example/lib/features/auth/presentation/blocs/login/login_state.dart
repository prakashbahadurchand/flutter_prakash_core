import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';

class LoginState extends FormCubitState<AuthUserModel> {
  final Field<String> email;
  final Field<String> password;
  final bool rememberMe;

  LoginState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    Field<String>? email,
    Field<String>? password,
    this.rememberMe = false,
  })  : email = email ??
            Field(
              value: '',
              labelText: 'Email Address',
              validators: Validators.required().email(),
            ),
        password = password ??
            Field(
              value: '',
              labelText: 'Password',
              validators: Validators.required(),
            );

  @override
  LoginState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    AuthUserModel? result,
    Field<String>? email,
    Field<String>? password,
    bool? rememberMe,
  }) {
    return LoginState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    email,
    password,
    rememberMe,
  ];
}
