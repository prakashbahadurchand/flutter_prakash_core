import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/common/data/repositories/common_repository.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/legal_state.dart';

@injectable
class LegalCubit extends BaseCubit<LegalState> {
  final CommonRepository _repository;

  LegalCubit(this._repository) : super(const LegalInitial());

  Future<void> loadPrivacyPolicy() async {
    safeEmit(const LegalLoading());
    final result = await _repository.getPrivacyPolicy();
    result.when(
      success: (doc) => safeEmit(LegalLoaded(doc)),
      error: (failure) => safeEmit(LegalFailure(failure.errorMessage)),
    );
  }

  Future<void> loadTermsAndConditions() async {
    safeEmit(const LegalLoading());
    final result = await _repository.getTermsAndConditions();
    result.when(
      success: (doc) => safeEmit(LegalLoaded(doc)),
      error: (failure) => safeEmit(LegalFailure(failure.errorMessage)),
    );
  }
}
