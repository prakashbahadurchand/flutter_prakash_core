/// Base Exception class for all data/infrastructure layer errors
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(
    super.message, {
    this.statusCode,
    super.code,
    super.details,
  });
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.details});
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No Internet Connection']);
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.details});
}

class NativePlatformException extends AppException {
  const NativePlatformException(super.message, {super.code, super.details});
}
