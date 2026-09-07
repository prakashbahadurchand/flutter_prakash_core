import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/common/data/repositories/common_repository.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/feedback_state.dart';

@injectable
class FeedbackCubit extends FormCubit<FeedbackState> {
  final CommonRepository _repository;

  FeedbackCubit(this._repository) : super(FeedbackState.initial());

  void onEmailChanged(String value) =>
      emit(state.copyWith(email: state.email(value)));

  void onFeedbackChanged(String value) =>
      emit(state.copyWith(feedback: state.feedback(value)));

  void reset() => emit(FeedbackState.initial());

  @override
  Future<Result<dynamic>> performSubmit() {
    return _repository.submitFeedback(state.toDto());
  }
}
