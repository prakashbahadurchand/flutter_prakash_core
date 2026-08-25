/// Sealed status for form cubits — no codegen required.
///
/// ```dart
/// if (status.isLoading) showSpinner();
/// if (status case BlocFailure(:final message)) showError(message);
/// ```
sealed class BlocStatus {
  const BlocStatus();

  const factory BlocStatus.initial() = BlocInitial;
  const factory BlocStatus.loading() = BlocLoading;
  const factory BlocStatus.success() = BlocSuccess;
  const factory BlocStatus.failure(String message) = BlocFailure;

  // ── Convenience getters ────────────────────────────────────────────────

  bool get isInitial => this is BlocInitial;
  bool get isLoading => this is BlocLoading;
  bool get isSuccess => this is BlocSuccess;
  bool get isFailure => this is BlocFailure;

  /// Returns the failure message if [BlocFailure], otherwise `null`.
  String? get failureMessage => switch (this) {
    BlocFailure(:final message) => message,
    _ => null,
  };
}

class BlocInitial extends BlocStatus {
  const BlocInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlocInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'BlocStatus.initial()';
}

class BlocLoading extends BlocStatus {
  const BlocLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlocLoading;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'BlocStatus.loading()';
}

class BlocSuccess extends BlocStatus {
  const BlocSuccess();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BlocSuccess;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'BlocStatus.success()';
}

class BlocFailure extends BlocStatus {
  final String message;
  const BlocFailure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlocFailure && message == other.message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'BlocStatus.failure($message)';
}
