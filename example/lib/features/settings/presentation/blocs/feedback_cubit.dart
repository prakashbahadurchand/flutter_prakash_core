import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/settings/data/models/feedback_request_model.dart';
import 'package:flutter_prakash_core_example/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/feedback_state.dart';

@injectable
class FeedbackCubit extends BaseFormCubit<FeedbackState, bool> {
  final SettingsRepository _repository;

  FeedbackCubit(this._repository) : super(FeedbackState());

  void onFeedbackChanged(String value) {
    final field = state.feedback(value);
    safeEmit(state.copyWith(
      feedback: field,
      isValid: field.isValid,
    ));
  }

  Future<void> submit() async {
    await submitForm(
      call: () => _repository.submitFeedback(
        FeedbackRequestModel(
          feedback: state.feedback.value,
          timestamp: DateTime.now(),
        ),
      ),
      onSuccess: (_) {
        emitEffect(
          const ShowToastEffect('Thank you! Your feedback has been received.'),
        );
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
