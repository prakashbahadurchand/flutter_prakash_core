import '../errors/failures.dart';
import 'result.dart';

/// A reactive async-state holder that models the lifecycle of an asynchronous
/// operation (loading → data | error). It pairs naturally with the package's
/// [Result] pattern: map a `Result<T>` into an [AsyncValue<T>] and rebuild
/// widgets based on the current state.
sealed class AsyncValue<T> {
  const AsyncValue();

  /// Factory for an idle / initial state (no fetch happened yet).
  const factory AsyncValue.idle() = AsyncIdle<T>;

  /// Factory for an in-flight operation.
  const factory AsyncValue.loading() = AsyncLoading<T>;

  /// Factory for a successfully completed operation.
  const factory AsyncValue.data(T value) = AsyncData<T>;

  /// Factory for a failed operation exposing a [Failure].
  const factory AsyncValue.error(Failure failure) = AsyncError<T>;

  bool get isIdle => this is AsyncIdle<T>;
  bool get isLoading => this is AsyncLoading<T>;
  bool get hasData => this is AsyncData<T>;
  bool get hasError => this is AsyncError<T>;

  /// The current value, or `null` if not in a data state.
  T? get valueOrNull => switch (this) {
    AsyncData<T>(:final value) => value,
    _ => null,
  };

  /// The current error, or `null` if not in an error state.
  Failure? get errorOrNull => switch (this) {
    AsyncError<T>(:final failure) => failure,
    _ => null,
  };

  /// Transforms the wrapped value without leaving the async state.
  R fold<R>({
    required R Function() onIdle,
    required R Function() onLoading,
    required R Function(T value) onData,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      AsyncIdle<T>() => onIdle(),
      AsyncLoading<T>() => onLoading(),
      AsyncData<T>(:final value) => onData(value),
      AsyncError<T>(:final failure) => onError(failure),
    };
  }
}

final class AsyncIdle<T> extends AsyncValue<T> {
  const AsyncIdle();
}

final class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
}

final class AsyncData<T> extends AsyncValue<T> {
  final T value;
  const AsyncData(this.value);
}

final class AsyncError<T> extends AsyncValue<T> {
  final Failure failure;
  const AsyncError(this.failure);
}

/// Convenience mapper from the package's core [Result] to [AsyncValue].
extension AsyncValueResultX<T> on Result<T> {
  AsyncValue<T> toAsyncValue() {
    return switch (this) {
      Success<T>(:final data) => AsyncValue.data(data),
      Fail<T>(:final failure) => AsyncValue.error(failure),
    };
  }
}
