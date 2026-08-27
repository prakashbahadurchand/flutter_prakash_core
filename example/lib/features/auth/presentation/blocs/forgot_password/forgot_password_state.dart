import 'package:flutter_prakash_core/flutter_prakash_core.dart';

class ForgotPasswordState extends FormCubitState<String> {
  final Field<String> email;

  ForgotPasswordState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    Field<String>? email,
  }) : email = email ??
            Field(
              value: '',
              labelText: 'Email Address',
              validators: Validators.required().email(),
            );

  @override
  ForgotPasswordState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    String? result,
    Field<String>? email,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [...super.props, email];
}
