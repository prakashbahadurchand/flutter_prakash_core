import 'package:flutter_prakash_core/flutter_prakash_core.dart';

class FeedbackState extends FormCubitState<bool> {
  final Field<String> feedback;

  FeedbackState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    Field<String>? feedback,
  }) : feedback = feedback ??
            Field(
              value: '',
              labelText: 'Feedback',
              validators: Validators.required(),
            );

  @override
  FeedbackState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    bool? result,
    Field<String>? feedback,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [...super.props, feedback];
}
