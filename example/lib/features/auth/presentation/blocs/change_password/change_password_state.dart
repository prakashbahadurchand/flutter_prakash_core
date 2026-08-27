import 'package:flutter_prakash_core/flutter_prakash_core.dart';

class ChangePasswordState extends FormCubitState<bool> {
  final Field<String> currentPassword;
  final Field<String> newPassword;
  final Field<String> confirmPassword;

  ChangePasswordState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    Field<String>? currentPassword,
    Field<String>? newPassword,
    Field<String>? confirmPassword,
  })  : currentPassword = currentPassword ??
            Field(
              value: '',
              labelText: 'Current Password',
              validators: Validators.required(),
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
              labelText: 'Confirm New Password',
              validators: Validators.required(),
            );

  @override
  ChangePasswordState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    bool? result,
    Field<String>? currentPassword,
    Field<String>? newPassword,
    Field<String>? confirmPassword,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    currentPassword,
    newPassword,
    confirmPassword,
  ];
}
