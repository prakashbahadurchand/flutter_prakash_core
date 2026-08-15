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

/// Enterprise Base Cubit offering streamlined state emission, side-effects, and async execution.
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  /// Single-shot UI side-effects publisher.
  final PublishSubject<UiEffect> _effectSubject = PublishSubject<UiEffect>();

  /// Stream of one-time UI effects (Toast, SnackBar, Navigation, Dialog).
  Stream<UiEffect> get effectStream => _effectSubject.stream;

  /// Emit a single-shot UI effect to subscribers.
  void emitEffect(UiEffect effect) {
    if (!_effectSubject.isClosed) {
      FlutterLogger.d(
        '[${runtimeType.toString()}] Emitting UI Effect: $effect',
      );
      _effectSubject.add(effect);
    }
  }

  /// Safely emits state if the Cubit is not closed.
  void safeEmit(State state) {
    if (!isClosed) emit(state);
  }

  @override
  Future<void> close() async {
    await _effectSubject.close();
    return super.close();
  }
}

/// Specialized Base Cubit for single-value UI lifecycle states ([UiState<T>]).
abstract class BaseUiCubit<T> extends BaseCubit<UiState<T>> {
  BaseUiCubit([super.initialState = const UiState.initial()]);

  /// Emit initial state.
  void emitInitial() => safeEmit(UiState<T>.initial());

  /// Emit loading state.
  void emitLoading({double? progress, String? message}) =>
      safeEmit(UiState<T>.loading(progress: progress, message: message));

  /// Emit success state.
  void emitSuccess(T data) => safeEmit(UiState<T>.success(data));

  /// Emit failure state.
  void emitFailure(Failure failure, {T? previousData}) =>
      safeEmit(UiState<T>.failure(failure, previousData: previousData));

  /// Emit empty state.
  void emitEmpty({String? message}) =>
      safeEmit(UiState<T>.empty(message: message));

  /// Automatically executes an async [Result] call and manages state lifecycle.
  Future<void> executeResult({
    required Future<Result<T>> Function() call,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    emitLoading();
    try {
      final result = await call();
      result.when(
        success: (data) {
          onSuccess?.call(data);
          emitSuccess(data);
        },
        error: (failure) {
          onError?.call(failure);
          emitFailure(failure);
        },
      );
    } catch (e, st) {
      FlutterLogger.e(
        'Unhandled exception in Cubit $runtimeType: $e',
        error: e,
        stackTrace: st,
      );
      final failure = UnexpectedFailure(e.toString());
      onError?.call(failure);
      emitFailure(failure);
    }
  }

  /// Automatically executes a `dartz` [Either] call and manages state lifecycle.
  Future<void> executeEither<L>({
    required Future<Either<L, T>> Function() call,
    Failure Function(L left)? failureMapper,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    emitLoading();
    try {
      final either = await call();
      final result = either.toResult(failureMapper: failureMapper);
      result.when(
        success: (data) {
          onSuccess?.call(data);
          emitSuccess(data);
        },
        error: (failure) {
          onError?.call(failure);
          emitFailure(failure);
        },
      );
    } catch (e, st) {
      FlutterLogger.e(
        'Unhandled exception in Cubit $runtimeType: $e',
        error: e,
        stackTrace: st,
      );
      final failure = UnexpectedFailure(e.toString());
      onError?.call(failure);
      emitFailure(failure);
    }
  }
}
