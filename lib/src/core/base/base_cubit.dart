import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_prakash/src/core/base/base_state.dart';

/// Reusable Base Cubit providing streamlined state emitting and error handling capabilities.
abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit([super.initialState = const StateInitial()]);

  /// Emit loading state.
  void emitLoading() => emit(StateLoading<T>());

  /// Emit success state with payload data.
  void emitSuccess(T data) => emit(StateSuccess<T>(data));

  /// Emit failure state with error message string.
  void emitFailure(String message) => emit(StateFailure<T>(message));

  /// Reset to initial state.
  void reset() => emit(StateInitial<T>());
}
