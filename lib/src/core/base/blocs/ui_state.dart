import 'package:equatable/equatable.dart';
import '../../network/failures.dart';

/// Sealed class representing the unified UI state lifecycle for asynchronous data fetching.
///
/// Features 5 distinct states:
/// - [UiStateInitial]: Initial idle state before any action is triggered.
/// - [UiStateLoading]: Operations are in progress (supports loading progress and status message).
/// - [UiStateSuccess]: Data has been fetched successfully.
/// - [UiStateFailure]: An error occurred (holds [Failure] and optional stale/cached data).
/// - [UiStateEmpty]: Data fetch succeeded but returned an empty dataset/content.
sealed class UiState<T> extends Equatable {
  const UiState();

  /// Initial idle state.
  const factory UiState.initial() = UiStateInitial<T>;

  /// Loading state with optional progress (0.0 to 1.0) and loading message.
  const factory UiState.loading({double? progress, String? message}) =
      UiStateLoading<T>;

  /// Success state with loaded payload [data].
  const factory UiState.success(T data) = UiStateSuccess<T>;

  /// Failure state with domain [failure] and optional previous/cached [previousData].
  const factory UiState.failure(Failure failure, {T? previousData}) =
      UiStateFailure<T>;

  /// Empty state when no data exists.
  const factory UiState.empty({String? message}) = UiStateEmpty<T>;

  // ===========================================================================
  // STATE CHECKERS
  // ===========================================================================

  bool get isInitial => this is UiStateInitial<T>;
  bool get isLoading => this is UiStateLoading<T>;
  bool get isSuccess => this is UiStateSuccess<T>;
  bool get isFailure => this is UiStateFailure<T>;
  bool get isEmpty => this is UiStateEmpty<T>;

  /// Convenient check if state is either initial or loading.
  bool get isBusy => isInitial || isLoading;

  // ===========================================================================
  // DATA EXTRACTION HELPERS
  // ===========================================================================

  /// Returns data if state is [UiStateSuccess], or optional previous data on failure, else `null`.
  T? get dataOrNull => switch (this) {
        UiStateSuccess<T>(:final data) => data,
        UiStateFailure<T>(:final previousData) => previousData,
        _ => null,
      };

  /// Returns failure if state is [UiStateFailure], else `null`.
  Failure? get failureOrNull => switch (this) {
        UiStateFailure<T>(:final failure) => failure,
        _ => null,
      };

  /// Returns data if available, or returns [fallback].
  T getOrElse(T fallback) => dataOrNull ?? fallback;

  // ===========================================================================
  // FUNCTIONAL PATTERN MATCHING
  // ===========================================================================

  /// Exhaustive pattern matching across all 5 states.
  R when<R>({
    required R Function() initial,
    required R Function(double? progress, String? message) loading,
    required R Function(T data) success,
    required R Function(Failure failure, T? previousData) failure,
    required R Function(String? message) empty,
  }) {
    final self = this;
    if (self is UiStateInitial<T>) {
      return initial();
    } else if (self is UiStateLoading<T>) {
      return loading(self.progress, self.message);
    } else if (self is UiStateSuccess<T>) {
      return success(self.data);
    } else if (self is UiStateFailure<T>) {
      return failure(self.failure, self.previousData);
    } else if (self is UiStateEmpty<T>) {
      return empty(self.message);
    }
    throw StateError('Unknown UiState: $self');
  }

  /// Partial pattern matching with optional fallbacks.
  R maybeWhen<R>({
    R Function()? initial,
    R Function(double? progress, String? message)? loading,
    R Function(T data)? success,
    R Function(Failure failure, T? previousData)? failure,
    R Function(String? message)? empty,
    required R Function() orElse,
  }) {
    final self = this;
    if (self is UiStateInitial<T> && initial != null) {
      return initial();
    } else if (self is UiStateLoading<T> && loading != null) {
      return loading(self.progress, self.message);
    } else if (self is UiStateSuccess<T> && success != null) {
      return success(self.data);
    } else if (self is UiStateFailure<T> && failure != null) {
      return failure(self.failure, self.previousData);
    } else if (self is UiStateEmpty<T> && empty != null) {
      return empty(self.message);
    }
    return orElse();
  }

  /// Simplified fold mapping success and failure/error states.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
    required R Function() onInitialOrLoading,
    R Function()? onEmpty,
  }) {
    final self = this;
    if (self is UiStateSuccess<T>) {
      return onSuccess(self.data);
    } else if (self is UiStateFailure<T>) {
      return onError(self.failure);
    } else if (self is UiStateEmpty<T> && onEmpty != null) {
      return onEmpty();
    } else {
      return onInitialOrLoading();
    }
  }

  /// Maps the internal success payload [T] to a new type [R].
  UiState<R> map<R>(R Function(T data) transform) {
    final self = this;
    if (self is UiStateInitial<T>) {
      return UiState<R>.initial();
    } else if (self is UiStateLoading<T>) {
      return UiState<R>.loading(progress: self.progress, message: self.message);
    } else if (self is UiStateSuccess<T>) {
      return UiState<R>.success(transform(self.data));
    } else if (self is UiStateFailure<T>) {
      return UiState<R>.failure(
        self.failure,
        previousData:
            self.previousData != null ? transform(self.previousData as T) : null,
      );
    } else if (self is UiStateEmpty<T>) {
      return UiState<R>.empty(message: self.message);
    }
    return UiState<R>.initial();
  }

  @override
  List<Object?> get props => [];
}

/// Initial idle state.
final class UiStateInitial<T> extends UiState<T> {
  const UiStateInitial();
}

/// Loading state.
final class UiStateLoading<T> extends UiState<T> {
  final double? progress;
  final String? message;

  const UiStateLoading({this.progress, this.message});

  @override
  List<Object?> get props => [progress, message];
}

/// Success state.
final class UiStateSuccess<T> extends UiState<T> {
  final T data;

  const UiStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

/// Failure state.
final class UiStateFailure<T> extends UiState<T> {
  final Failure failure;
  final T? previousData;

  const UiStateFailure(this.failure, {this.previousData});

  @override
  List<Object?> get props => [failure, previousData];
}

/// Empty state.
final class UiStateEmpty<T> extends UiState<T> {
  final String? message;

  const UiStateEmpty({this.message});

  @override
  List<Object?> get props => [message];
}
