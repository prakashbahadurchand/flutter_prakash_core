import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/common/data/models/feedback_request_model.dart';
import 'package:flutter_prakash_core_example/features/common/data/repositories/common_repository.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/feedback_state.dart';

@injectable
class FeedbackCubit extends BaseFormCubit<FeedbackState, bool> {
  final CommonRepository _repository;

  FeedbackCubit(this._repository) : super(FeedbackState());

  void onFeedbackChanged(String value) {
    final field = state.feedback(value);
    _validate(feedback: field);
  }

  void onEmailChanged(String value) {
    final field = state.email(value);
    _validate(email: field);
  }

  void _validate({Field<String>? feedback, Field<String>? email}) {
    final curFeedback = feedback ?? state.feedback;
    final curEmail = email ?? state.email;

    final isValid = curFeedback.isValid && curFeedback.value.trim().length >= 10;

    safeEmit(state.copyWith(
      feedback: curFeedback,
      email: curEmail,
      isValid: isValid,
    ));
  }

  Future<void> submit() async {
    if (!state.isValid) return;

    await submitForm(
      call: () => _repository.submitFeedback(
        FeedbackRequestModel(
          feedback: state.feedback.value,
          userEmail: state.email.value.isEmpty ? null : state.email.value,
          timestamp: DateTime.now(),
        ),
      ),
      onSuccess: (_) {
        emitEffect(
          const ShowToastEffect('Thank you! Your feedback has been sent.'),
        );
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
