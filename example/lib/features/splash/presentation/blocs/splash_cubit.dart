import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/splash/data/repositories/splash_repository.dart';
import 'package:flutter_prakash_core_example/features/splash/presentation/blocs/splash_state.dart';

@injectable
class SplashCubit extends BaseCubit<SplashState> {
  final SplashRepository _repository;

  SplashCubit(this._repository) : super(const SplashInitial());

  Future<void> initialize() async {
    safeEmit(const SplashLoading());

    // Allow splash animation to play smoothly
    await Future.delayed(const Duration(milliseconds: 1400));

    final result = await _repository.initializeApp();

    result.when(
      success: (initModel) {
        safeEmit(SplashSuccess(initModel));
      },
      error: (failure) {
        safeEmit(SplashFailure(failure.errorMessage));
      },
    );
  }
}
