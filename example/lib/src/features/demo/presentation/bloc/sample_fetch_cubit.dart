import 'package:flutter_prakash/flutter_prakash.dart';

/// Sample Cubit demonstrating the simplest data-fetching pattern with [BaseUiCubit].
///
/// Uses [executeResult] to automatically handle loading, success, and error UI lifecycle states.
class SampleFetchCubit extends BaseUiCubit<List<String>> {
  SampleFetchCubit() {
    fetchFeatures();
  }

  /// Fetches enterprise features list asynchronously using [executeResult].
  Future<void> fetchFeatures() async {
    await executeResult(
      call: () async {
        await Future.delayed(const Duration(milliseconds: 600));
        return Result.fromAsync(
          call: () async => const [
            'BaseBloc & BaseCubit State Management Engine',
            'UiState 5-State Sealed Lifecycle (initial, loading, success, failure, empty)',
            'BaseFormCubit + Formz Validators (Email, Password, Phone, URL)',
            'BasePagingCubit Infinite Scrolling Engine',
            'RxDart Event Transformers (debounce, throttle, restartable, droppable)',
            'PrakashEffectListener Single-Shot Side-Effects Channel',
            'Dartz Either Interoperability Extensions',
            'PrakashDI Unified GetIt Container',
            'PrakashRouteGuard & PrakashRouteObserver for AutoRoute',
            'EnterpriseBlocObserver Global State Monitor',
            'FlutterLogger ANSI Color Syntax & Top-level Helpers',
            'Result.fromAsync() Safe Result Mapper',
            'AppRestartWrapper Hot Rebuilding Wrapper',
          ],
        );
      },
      onSuccess: (data) {
        emitEffect(ShowToastEffect('Loaded ${data.length} enterprise features'));
      },
    );
  }
}
