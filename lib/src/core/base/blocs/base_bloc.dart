import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dartz/dartz.dart' hide State, Order;
import '../../loggers/flutter_logger.dart';
import '../../network/failures.dart';
import '../../network/result.dart';
import 'dartz_extensions.dart';
import 'ui_effect.dart';
import 'ui_state.dart';

/// Enterprise-grade Base BLoC eliminating boilerplate across Flutter applications.
///
/// Features:
/// - Single-shot UI Side-Effects channel via [effectStream] and [emitEffect].
/// - Safe state emission via [safeEmit].
/// - Automatic async operation handling via [handleResult] and [handleEither].
/// - Integrated logging via [FlutterLogger].
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  /// Single-shot UI side-effects publisher.
  final PublishSubject<UiEffect> _effectSubject = PublishSubject<UiEffect>();

  /// Stream of one-time UI effects (Toast, SnackBar, Navigation, Dialog).
  Stream<UiEffect> get effectStream => _effectSubject.stream;

  /// Emit a single-shot UI effect to subscribers.
  void emitEffect(UiEffect effect) {
    if (!_effectSubject.isClosed) {
      FlutterLogger.d('[${runtimeType.toString()}] Emitting UI Effect: $effect');
      _effectSubject.add(effect);
    }
  }

  /// Safely emits [state] using event handler [emitter] only if the BLoC is not closed.
  void safeEmit(State state, Emitter<State> emitter) {
    if (!isClosed) {
      emitter(state);
    }
  }

  /// Executes an async [ResultFuture] call and maps it to UI states automatically.
  Future<void> handleResult<T>({
    required Future<Result<T>> Function() call,
    required Emitter<State> emit,
    required State Function(UiState<T> uiState) builder,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    safeEmit(builder(const UiState.loading()), emit);
    try {
      final result = await call();
      result.when(
        success: (data) {
          onSuccess?.call(data);
          safeEmit(builder(UiState.success(data)), emit);
        },
        error: (failure) {
          onError?.call(failure);
          safeEmit(builder(UiState.failure(failure)), emit);
        },
      );
    } catch (e, st) {
      FlutterLogger.e('Unhandled exception in BLoC $runtimeType: $e', error: e, stackTrace: st);
      final failure = UnexpectedFailure(e.toString());
      onError?.call(failure);
      safeEmit(builder(UiState.failure(failure)), emit);
    }
  }

  /// Executes a `dartz` [Either] async call and maps it to UI states automatically.
  Future<void> handleEither<L, R>({
    required Future<Either<L, R>> Function() call,
    required Emitter<State> emit,
    required State Function(UiState<R> uiState) builder,
    Failure Function(L left)? failureMapper,
    void Function(R data)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    safeEmit(builder(const UiState.loading()), emit);
    try {
      final either = await call();
      final result = either.toResult(failureMapper: failureMapper);
      result.when(
        success: (data) {
          onSuccess?.call(data);
          safeEmit(builder(UiState.success(data)), emit);
        },
        error: (failure) {
          onError?.call(failure);
          safeEmit(builder(UiState.failure(failure)), emit);
        },
      );
    } catch (e, st) {
      FlutterLogger.e('Unhandled exception in BLoC $runtimeType: $e', error: e, stackTrace: st);
      final failure = UnexpectedFailure(e.toString());
      onError?.call(failure);
      safeEmit(builder(UiState.failure(failure)), emit);
    }
  }

  @override
  Future<void> close() async {
    await _effectSubject.close();
    return super.close();
  }
}
