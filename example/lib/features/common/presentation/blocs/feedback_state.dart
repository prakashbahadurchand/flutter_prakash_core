import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/common/data/models/feedback_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_state.freezed.dart';

@freezed
abstract class FeedbackState
    with _$FeedbackState, FormMixin
    implements FormState {
  const FeedbackState._();

  const factory FeedbackState({
    required Field<String> email,
    required Field<String> feedback,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _FeedbackState;

  factory FeedbackState.initial() => FeedbackState(
    email: Fields.email(
      labelText: 'Email Address (Optional)',
      hintText: 'Enter your email for follow-up...',
      isRequired: false,
    ),
    feedback: Fields.text(
      labelText: 'Feedback / Report',
      hintText: 'Describe your feedback or issue...',
      minLength: 10,
    ),
  );

  @override
  List<Field<dynamic>> get formFields => [feedback];

  @override
  FeedbackState copyWithStatus(BlocStatus status) => copyWith(status: status);

  @override
  FeedbackState makeAllDirty() =>
      copyWith(email: email.makeDirty(), feedback: feedback.makeDirty());

  FeedbackRequestModel toDto() => FeedbackRequestModel(
    feedback: feedback.value.trim(),
    userEmail: email.value.trim().isEmpty ? null : email.value.trim(),
    timestamp: DateTime.now(),
  );
}
