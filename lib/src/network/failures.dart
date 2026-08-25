import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  /// Helper getter to extract the error message.
  String get errorMessage => message;

  @override
  List<Object?> get props => [message];
}

/// Represents a failure originating from server interactions.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents a failure originating from local caching or storage.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents a failure due to lack of network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Please check your internet connection',
  ]);
}

/// Represents a failure when data parsing/mapping fails.
class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Failed to process data format']);
}

/// Represents an authentication or session-related failure.
class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Authentication failed. Please log in again.',
  ]);
}

/// Represents a failure due to missing or denied system permissions.
class PermissionFailure extends Failure {
  final String? permissionName;
  const PermissionFailure([
    super.message = 'Required permission was denied.',
    this.permissionName,
  ]);

  @override
  List<Object?> get props => [message, permissionName];
}

/// Represents a failure during file selection or file system access.
class FilePickerFailure extends Failure {
  const FilePickerFailure([
    super.message = 'File selection failed or was aborted.',
  ]);
}

/// Represents a failure when an operation times out.
class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Request timed out. Please try again.',
  ]);
}

/// Represents a failure when an operation is cancelled by the user.
class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Operation was cancelled.']);
}

/// Represents a client-side or form validation failure.
class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  const ValidationFailure(super.message, [this.errors]);

  @override
  List<Object?> get props => [message, errors];
}

/// Represents a generic or unexpected failure fallback.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
