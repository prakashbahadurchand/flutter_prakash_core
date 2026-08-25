/// Sealed UI state for data-fetching cubits — no codegen required.
///
/// ```dart
/// switch (state) {
///   UiInitial()   => showPlaceholder(),
///   UiLoading()   => showSpinner(),
///   UiSuccess(:final data) => showData(data),
///   UiFailure(:final message) => showError(message),
/// }
/// ```
sealed class UiState<T> {
  const UiState();

  const factory UiState.initial() = UiInitial<T>;
  const factory UiState.loading() = UiLoading<T>;
  const factory UiState.success(T data) = UiSuccess<T>;
  const factory UiState.failure(String message) = UiFailure<T>;

  // ── Convenience getters ────────────────────────────────────────────────

  bool get isInitial => this is UiInitial<T>;
  bool get isLoading => this is UiLoading<T>;
  bool get isSuccess => this is UiSuccess<T>;
  bool get isFailure => this is UiFailure<T>;

  /// Returns the data if [UiSuccess], otherwise `null`.
  T? get dataOrNull => switch (this) {
    UiSuccess<T>(:final data) => data,
    _ => null,
  };

  /// Returns the error message if [UiFailure], otherwise `null`.
  String? get errorMessage => switch (this) {
    UiFailure<T>(:final message) => message,
    _ => null,
  };

  /// Functional pattern matching for all four states.
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    return switch (this) {
      UiInitial<T>() => initial(),
      UiLoading<T>() => loading(),
      UiSuccess<T>(:final data) => success(data),
      UiFailure<T>(:final message) => failure(message),
    };
  }

  /// Pattern matching with fallback [orElse] for unhandled states.
  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(String message)? failure,
    required R Function() orElse,
  }) {
    return switch (this) {
      UiInitial<T>() => initial?.call() ?? orElse(),
      UiLoading<T>() => loading?.call() ?? orElse(),
      UiSuccess<T>(:final data) => success?.call(data) ?? orElse(),
      UiFailure<T>(:final message) => failure?.call(message) ?? orElse(),
    };
  }
}

class UiInitial<T> extends UiState<T> {
  const UiInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UiInitial<T>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'UiState<$T>.initial()';
}

class UiLoading<T> extends UiState<T> {
  const UiLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UiLoading<T>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'UiState<$T>.loading()';
}

class UiSuccess<T> extends UiState<T> {
  final T data;
  const UiSuccess(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UiSuccess<T> && other.data == data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'UiState<$T>.success($data)';
}

class UiFailure<T> extends UiState<T> {
  final String message;
  const UiFailure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UiFailure<T> && other.message == message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'UiState<$T>.failure($message)';
}
