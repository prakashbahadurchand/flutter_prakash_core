import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fp_effects.dart';
import '../../network/result.dart';
import 'ui_state.dart';

/// Enterprise base Bloc with lifecycle-safe emit, side-effect stream,
/// and [Result]-to-[UiState] conversion helpers.
///
/// ### Features:
/// - [safeEmit] — guards against `emit` after `close()`.
/// - [emitEffect] — fires one-shot side-effects via [effectStream].
/// - [handleResult] — converts `Result<T>` to `UiState<T>` and emits.
///
/// ### Usage:
/// ```dart
/// class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
///   SearchBloc() : super(const SearchState()) {
///     on<SearchQueryChanged>(
///       _onQueryChanged,
///       transformer: FpEventTransformers.debounce(
///         const Duration(milliseconds: 300),
///       ),
///     );
///   }
///
///   Future<void> _onQueryChanged(
///     SearchQueryChanged event,
///     Emitter<SearchState> emit,
///   ) async {
///     safeEmit(state.copyWith(query: event.query), emit);
///     await handleResult<List<String>>(
///       call: () => repository.search(event.query),
///       emit: emit,
///       builder: (uiState) => state.copyWith(resultState: uiState),
///     );
///   }
/// }
/// ```
abstract class BaseBloc<E, S> extends Bloc<E, S> implements FpEffectEmitter {
  BaseBloc(super.initialState);

  final StreamController<FpEffect> _effectController =
      StreamController<FpEffect>.broadcast();

  /// Stream of one-shot side-effects consumed by [FpEffectListener].
  @override
  Stream<FpEffect> get effectStream => _effectController.stream;

  /// Lifecycle-safe emit for Bloc event handlers.
  void safeEmit(S newState, Emitter<S> emit) {
    if (!isClosed) {
      emit(newState);
    }
  }

  /// Fires a one-shot [FpEffect] to the UI layer.
  void emitEffect(FpEffect effect) {
    if (!_effectController.isClosed) {
      _effectController.add(effect);
    }
  }

  /// Converts a [Result]-returning async call into [UiState] transitions.
  ///
  /// 1. Emits `UiState.loading()` via [builder]
  /// 2. Calls [call] to obtain `Result<T>`
  /// 3. Maps success → `UiState.success(data)`, error → `UiState.failure(message)`
  Future<void> handleResult<T>({
    required Future<Result<T>> Function() call,
    required Emitter<S> emit,
    required S Function(UiState<T> uiState) builder,
  }) async {
    safeEmit(builder(const UiState.loading()), emit);

    final result = await call();
    result.when(
      success: (data) {
        safeEmit(builder(UiState.success(data)), emit);
      },
      error: (failure) {
        safeEmit(builder(UiState.failure(failure.errorMessage)), emit);
      },
    );
  }

  @override
  Future<void> close() {
    unawaited(_effectController.close());
    return super.close();
  }
}
