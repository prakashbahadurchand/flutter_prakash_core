import 'package:equatable/equatable.dart';

/// Base Failure class for domain & presentation layer error handling
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode, super.code});

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class NativePlatformFailure extends Failure {
  const NativePlatformFailure(super.message, {super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
