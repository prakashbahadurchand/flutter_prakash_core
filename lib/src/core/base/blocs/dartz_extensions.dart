import 'package:dartz/dartz.dart';
import '../../network/failures.dart';
import '../../network/result.dart';
import 'ui_state.dart';

/// Extension methods for `dartz` [Either] to seamlessly interoperate with [Result] and [UiState].
extension DartzEitherX<L, R> on Either<L, R> {
  /// Converts a `dartz` [Either] into a clean architecture [Result].
  Result<R> toResult({Failure Function(L left)? failureMapper}) {
    return fold(
      (left) {
        if (left is Failure) {
          return Result<R>.error(left);
        }
        if (failureMapper != null) {
          return Result<R>.error(failureMapper(left));
        }
        return Result<R>.error(UnexpectedFailure(left.toString()));
      },
      (right) => Result<R>.success(right),
    );
  }

  /// Converts a `dartz` [Either] directly into a [UiState].
  UiState<R> toUiState({Failure Function(L left)? failureMapper}) {
    return fold(
      (left) {
        if (left is Failure) {
          return UiState<R>.failure(left);
        }
        if (failureMapper != null) {
          return UiState<R>.failure(failureMapper(left));
        }
        return UiState<R>.failure(UnexpectedFailure(left.toString()));
      },
      (right) => UiState<R>.success(right),
    );
  }

  /// Extract value or return null.
  R? get rightOrNull => fold((_) => null, (r) => r);

  /// Extract left error or return null.
  L? get leftOrNull => fold((l) => l, (_) => null);
}

/// Extension on [Result] to convert to `dartz` [Either].
extension ResultToDartzX<T> on Result<T> {
  /// Converts a [Result] into a `dartz` [Either<Failure, T>].
  Either<Failure, T> toEither() {
    return fold(
      onSuccess: (data) => Right<Failure, T>(data),
      onError: (failure) => Left<Failure, T>(failure),
    );
  }
}

/// Extension on [Result] to convert directly into a [UiState].
extension ResultToUiStateX<T> on Result<T> {
  /// Converts a [Result] directly to a [UiState<T>].
  UiState<T> toUiState() {
    return when(
      success: (data) => UiState<T>.success(data),
      error: (failure) => UiState<T>.failure(failure),
    );
  }
}
