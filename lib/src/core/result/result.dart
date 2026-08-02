import '../errors/failures.dart';

/// Functional Result pattern eliminating Try-Catch boilerplate across apps
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = Fail<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Fail<T>;

  T? get dataOrNull => switch (this) {
    Success(data: final d) => d,
    Fail() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Fail(failure: final f) => f,
  };

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Fail(failure: final failure) => onFailure(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Fail<T> extends Result<T> {
  final Failure failure;
  const Fail(this.failure);
}
