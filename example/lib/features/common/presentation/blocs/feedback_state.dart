import 'package:flutter_prakash_core/flutter_prakash_core.dart';

class FeedbackState extends FormCubitState<bool> {
  final Field<String> feedback;
  final Field<String> email;

  FeedbackState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    Field<String>? feedback,
    Field<String>? email,
  })  : feedback = feedback ??
            Field(
              labelText: 'Feedback / Report',
              hintText: 'Describe your feedback or issue...',
              value: '',
              validators: Validators.required().minLength(10),
            ),
        email = email ??
            Field(
              labelText: 'Email Address (Optional)',
              hintText: 'Enter your email for follow-up...',
              value: '',
            );

  @override
  FeedbackState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    bool? result,
    Field<String>? feedback,
    Field<String>? email,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      feedback: feedback ?? this.feedback,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        feedback,
        email,
      ];
}
