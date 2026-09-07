import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/forgot_password_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
abstract class ForgotPasswordState
    with _$ForgotPasswordState, FormMixin
    implements FormState {
  const ForgotPasswordState._();

  const factory ForgotPasswordState({
    required Field<String> email,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _ForgotPasswordState;

  factory ForgotPasswordState.initial() => ForgotPasswordState(
    email: Fields.email(labelText: 'Email Address'),
  );

  @override
  List<Field<dynamic>> get formFields => [email];

  @override
  ForgotPasswordState copyWithStatus(BlocStatus status) =>
      copyWith(status: status);

  @override
  ForgotPasswordState makeAllDirty() => copyWith(email: email.makeDirty());

  ForgotPasswordRequestModel toDto() =>
      ForgotPasswordRequestModel(email: email.value.trim());
}
