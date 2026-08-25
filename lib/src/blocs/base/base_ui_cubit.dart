import '../../network/result.dart';
import 'base_cubit.dart';
import 'ui_state.dart';

/// Enterprise base UI cubit for data-fetching operations.
///
/// Manages `UiState<T>` lifecycle (initial → loading → success/failure)
/// with built-in [Result] integration and side-effect support.
///
/// ### Usage:
/// ```dart
/// @injectable
/// class ProductListCubit extends BaseUiCubit<List<Product>> {
///   final ProductRepository _repo;
///   ProductListCubit(this._repo) { load(); }
///
///   Future<void> load() => executeResult(
///     call: () => _repo.fetchProducts(),
///     onSuccess: (products) {
///       emitEffect(ShowToastEffect('Loaded ${products.length} products'));
///     },
///   );
/// }
/// ```
abstract class BaseUiCubit<T> extends BaseCubit<UiState<T>> {
  BaseUiCubit() : super(const UiState.initial());

  /// Executes an async [call] returning `Result<T>`, automatically managing
  /// the `UiState` lifecycle transitions.
  ///
  /// - Emits `UiState.loading()` before the call.
  /// - On success, emits `UiState.success(data)` and invokes [onSuccess].
  /// - On error, emits `UiState.failure(message)` and invokes [onError].
  Future<void> executeResult({
    required Future<Result<T>> Function() call,
    void Function(T data)? onSuccess,
    void Function(String errorMessage)? onError,
  }) async {
    safeEmit(const UiState.loading());

    final result = await call();
    result.when(
      success: (data) {
        safeEmit(UiState.success(data));
        onSuccess?.call(data);
      },
      error: (failure) {
        final msg = failure.errorMessage;
        safeEmit(UiState.failure(msg));
        onError?.call(msg);
      },
    );
  }
}
