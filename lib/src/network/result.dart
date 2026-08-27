import 'dart:async' as async;
import 'exceptions.dart' hide TimeoutException;
import 'failures.dart';

/// Type alias for cleaner repository signatures.
/// Example: `FutureResult<User>` instead of `Future<Result<User>>`
typedef FutureResult<T> = async.Future<Result<T>>;

/// A sealed class representing either a successful outcome with data [T]
/// or a failed outcome with a domain [Failure].
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result] containing the given [data].
  const factory Result.success(T data) = Success<T>;

  /// Creates a failed [Result] containing the given domain [failure].
  const factory Result.error(Failure failure) = Error<T>;

  /// Executes an asynchronous [call], automatically wrapping it in a [Result].
  ///
  /// - Catches any thrown exceptions and processes them via optional [onError].
  /// - Runs optional [onSuccess] when the call succeeds.
  static FutureResult<T> fromAsync<T>({
    required async.Future<T> Function() call,
    T Function(T data)? onSuccess,
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      final data = await call();
      final processedData = onSuccess != null ? onSuccess(data) : data;
      return Result.success(processedData);
    } catch (error, stackTrace) {
      if (onError != null) {
        return Result.error(onError(error, stackTrace));
      }

      // Default fallback conversion if no custom onError is provided
      if (error is Failure) {
        return Result.error(error);
      }

      if (error is ServerException) {
        return Result.error(ServerFailure(error.message));
      } else if (error is CacheException) {
        return Result.error(CacheFailure(error.message));
      } else if (error is NetworkException) {
        return Result.error(const NetworkFailure());
      } else if (error is ParsingException) {
        return Result.error(ParsingFailure(error.message));
      } else if (error is AuthException) {
        return Result.error(AuthFailure(error.message));
      } else if (error is PermissionDeniedException) {
        return Result.error(
          PermissionFailure(error.message, error.permissionName),
        );
      } else if (error is FilePickerException) {
        return Result.error(FilePickerFailure(error.message));
      } else if (error is AppTimeoutException) {
        return Result.error(TimeoutFailure(error.message));
      } else if (error is async.TimeoutException) {
        return Result.error(
          TimeoutFailure(
            error.message ?? 'Request timed out. Please try again.',
          ),
        );
      } else if (error is CancellationException) {
        return Result.error(CancelledFailure(error.message));
      } else if (error is ValidationException) {
        return Result.error(ValidationFailure(error.message, error.errors));
      }

      return Result.error(UnexpectedFailure(error.toString()));
    }
  }

  /// Functional pattern matching for UI or BLoC consumption.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Error<T>(:final failure) => error(failure),
    };
  }

  /// Alias for [when]. Maps either success or error to a single value.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return when(success: onSuccess, error: onError);
  }

  /// Transforms the success value using [transform].
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Result.success(transform(data)),
      Error<T>(:final failure) => Result.error(failure),
    };
  }

  /// Transforms the success value into a new [Result] using [transform].
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => transform(data),
      Error<T>(:final failure) => Result.error(failure),
    };
  }

  /// Returns the data if success, or null if error.
  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    Error<T>() => null,
  };

  /// Returns the failure if error, or null if success.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    Error<T>(:final failure) => failure,
  };

  /// Returns the data if success, or [fallback] if error.
  T getOrElse(T fallback) => switch (this) {
    Success<T>(:final data) => data,
    Error<T>() => fallback,
  };

  /// Returns data if success, or throws the underlying exception/failure.
  T get dataOrThrow => switch (this) {
    Success<T>(:final data) => data,
    Error<T>(:final failure) => throw failure,
  };

  /// Returns true if the result is a success.
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is an error.
  bool get isError => this is Error<T>;
}

/// Represents a successful [Result] state.
final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Result<$T>.success($data)';
}

/// Represents a failed [Result] state containing a domain [Failure].
final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Error<T> && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Result<$T>.error($failure)';
}
