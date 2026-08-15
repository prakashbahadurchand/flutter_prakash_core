import 'package:equatable/equatable.dart';
import '../../network/failures.dart';
import 'ui_state.dart';

/// Legacy/Simplified Base State wrapper compatible with Equatable.
///
/// For full enterprise-grade reactive lifecycle, see [UiState].
sealed class BaseState<T> extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

/// Initial state representation.
class StateInitial<T> extends BaseState<T> {
  const StateInitial();
}

/// Loading state representation.
class StateLoading<T> extends BaseState<T> {
  const StateLoading();
}

/// Success state with payload data.
class StateSuccess<T> extends BaseState<T> {
  final T data;
  const StateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

/// Failure state with error message string.
class StateFailure<T> extends BaseState<T> {
  final String message;
  final Failure? failure;

  const StateFailure(this.message, [this.failure]);

  @override
  List<Object?> get props => [message, failure];
}

/// Helper extensions to seamlessly convert between legacy [BaseState] and enterprise [UiState].
extension BaseStateToUiState<T> on BaseState<T> {
  UiState<T> toUiState() {
    return switch (this) {
      StateInitial<T>() => UiState<T>.initial(),
      StateLoading<T>() => UiState<T>.loading(),
      StateSuccess<T>(:final data) => UiState<T>.success(data),
      StateFailure<T>(:final message, :final failure) => UiState<T>.failure(
        failure ?? UnexpectedFailure(message),
      ),
    };
  }
}
