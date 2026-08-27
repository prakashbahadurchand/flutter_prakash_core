import 'package:equatable/equatable.dart';

/// Base class for all data-layer exceptions.
abstract class AppException implements Exception, Equatable {
  const AppException();

  @override
  bool get stringify => true;
}

/// Thrown when a remote server request fails (e.g., Dio, Supabase, HTTP errors).
class ServerException extends AppException {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

/// Thrown when local caching or storage fails (e.g., Hive, SharedPreferences).
class CacheException extends AppException {
  final String message;

  const CacheException({this.message = 'Cache operation failed'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when there is no internet connection.
class NetworkException extends AppException {
  const NetworkException();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'NetworkException: No internet connection';
}

/// Thrown when a parsing or serialization error occurs.
class ParsingException extends AppException {
  final String message;

  const ParsingException({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ParsingException: $message';
}

/// Thrown when authentication or authorization fails (e.g., invalid tokens, 401/403).
class AuthException extends AppException {
  final String message;
  final int? statusCode;

  const AuthException({
    this.message = 'Authentication failed',
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => 'AuthException: $message (Code: $statusCode)';
}

/// Thrown when a required permission is denied or restricted.
class PermissionDeniedException extends AppException {
  final String permissionName;
  final String message;

  const PermissionDeniedException({
    required this.permissionName,
    this.message = 'Permission denied',
  });

  @override
  List<Object?> get props => [permissionName, message];

  @override
  String toString() => 'PermissionDeniedException: $permissionName - $message';
}

/// Thrown when file picking, reading, or access operations fail.
class FilePickerException extends AppException {
  final String message;

  const FilePickerException({this.message = 'Failed to pick or access file'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'FilePickerException: $message';
}

/// Thrown when an operation exceeds its specified time limit.
class AppTimeoutException extends AppException {
  final String message;

  const AppTimeoutException({this.message = 'Operation timed out'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AppTimeoutException: $message';
}

/// Backwards compatibility alias for [AppTimeoutException].
@Deprecated(
  'Use AppTimeoutException to avoid collision with dart:async.TimeoutException',
)
typedef TimeoutException = AppTimeoutException;

/// Thrown when an asynchronous operation is explicitly cancelled by user or system.
class CancellationException extends AppException {
  final String message;

  const CancellationException({this.message = 'Operation was cancelled'});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'CancellationException: $message';
}

/// Thrown when client-side input or data validation fails.
class ValidationException extends AppException {
  final String message;
  final Map<String, String>? errors;

  const ValidationException({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];

  @override
  String toString() => 'ValidationException: $message (Errors: $errors)';
}
