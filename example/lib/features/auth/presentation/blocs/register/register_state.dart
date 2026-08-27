import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';

class RegisterState extends FormCubitState<AuthUserModel> {
  final Field<String> fullName;
  final Field<String> email;
  final Field<String> password;
  final Field<String> confirmPassword;
  final bool agreeToTerms;

  RegisterState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    Field<String>? fullName,
    Field<String>? email,
    Field<String>? password,
    Field<String>? confirmPassword,
    this.agreeToTerms = false,
  })  : fullName = fullName ??
            Field(
              value: '',
              labelText: 'Full Name',
              validators: Validators.required(),
            ),
        email = email ??
            Field(
              value: '',
              labelText: 'Email Address',
              validators: Validators.required().email(),
            ),
        password = password ??
            Field(
              value: '',
              labelText: 'Password',
              validators: Validators.required().minLength(6),
            ),
        confirmPassword = confirmPassword ??
            Field(
              value: '',
              labelText: 'Confirm Password',
              validators: Validators.required(),
            );

  @override
  RegisterState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    AuthUserModel? result,
    Field<String>? fullName,
    Field<String>? email,
    Field<String>? password,
    Field<String>? confirmPassword,
    bool? agreeToTerms,
  }) {
    return RegisterState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    fullName,
    email,
    password,
    confirmPassword,
    agreeToTerms,
  ];
}
