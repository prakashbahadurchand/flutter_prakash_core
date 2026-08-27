import 'dart:async' as async;
import 'package:flutter_prakash_core/src/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result<T> Functional Error Handling', () {
    test('Result.success holds data and reports correct flags', () {
      const result = Result.success('Enterprise Data');

      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect(result.dataOrNull, equals('Enterprise Data'));
      expect(result.failureOrNull, isNull);
      expect(result.dataOrThrow, equals('Enterprise Data'));
      expect(result.getOrElse('Fallback'), equals('Enterprise Data'));
    });

    test('Result.error holds failure and reports correct flags', () {
      const failure = ServerFailure('Internal Server Error');
      const result = Result<String>.error(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isError, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, equals(failure));
      expect(result.getOrElse('Fallback'), equals('Fallback'));
      expect(() => result.dataOrThrow, throwsA(isA<ServerFailure>()));
    });

    test('Result.when calls appropriate callbacks', () {
      const successResult = Result.success(42);
      final successValue = successResult.when(
        success: (data) => 'Value is $data',
        error: (failure) => 'Failed: ${failure.errorMessage}',
      );
      expect(successValue, equals('Value is 42'));

      const failureResult = Result<int>.error(NetworkFailure('No Internet'));
      final failureValue = failureResult.when(
        success: (data) => 'Value is $data',
        error: (failure) => 'Failed: ${failure.errorMessage}',
      );
      expect(failureValue, equals('Failed: No Internet'));
    });

    test('Result.fold transforms both branches', () {
      const successResult = Result.success('Hello');
      expect(
        successResult.fold(
          onSuccess: (val) => val.toUpperCase(),
          onError: (err) => 'ERROR',
        ),
        equals('HELLO'),
      );

      const failureResult = Result<String>.error(
        ValidationFailure('Invalid field'),
      );
      expect(
        failureResult.fold(
          onSuccess: (val) => val.toUpperCase(),
          onError: (err) => err.errorMessage,
        ),
        equals('Invalid field'),
      );
    });

    test('Result.map transforms success value and preserves failure', () {
      const successResult = Result.success(10);
      final mappedSuccess = successResult.map((val) => val * 2);
      expect(mappedSuccess.dataOrNull, equals(20));

      const failureResult = Result<int>.error(
        TimeoutFailure('Request Timed Out'),
      );
      final mappedFailure = failureResult.map((val) => val * 2);
      expect(mappedFailure.isError, isTrue);
      expect(mappedFailure.failureOrNull, isA<TimeoutFailure>());
    });

    test('Result.flatMap chains Result computations', () {
      const successResult = Result.success('100');
      final chainedSuccess = successResult.flatMap((str) {
        final parsed = int.tryParse(str);
        return parsed != null
            ? Result.success(parsed)
            : const Result.error(ValidationFailure('Not a number'));
      });
      expect(chainedSuccess.dataOrNull, equals(100));

      const invalidResult = Result.success('invalid');
      final chainedFailure = invalidResult.flatMap((str) {
        final parsed = int.tryParse(str);
        return parsed != null
            ? Result.success(parsed)
            : const Result.error(ValidationFailure('Not a number'));
      });
      expect(chainedFailure.isError, isTrue);
      expect(
        chainedFailure.failureOrNull?.errorMessage,
        equals('Not a number'),
      );
    });

    test(
      'Result.fromAsync catches exceptions and converts to Failure',
      () async {
        final success = await Result.fromAsync(
          call: () async => 'Async Success',
        );
        expect(success.dataOrNull, equals('Async Success'));

        final serverError = await Result.fromAsync<String>(
          call: () async {
            throw const ServerException(
              message: 'Server exploded',
              statusCode: 500,
            );
          },
        );
        expect(serverError.isError, isTrue);
        expect(serverError.failureOrNull, isA<ServerFailure>());
        expect(
          serverError.failureOrNull?.errorMessage,
          equals('Server exploded'),
        );

        final networkError = await Result.fromAsync<String>(
          call: () async {
            throw const NetworkException();
          },
        );
        expect(networkError.failureOrNull, isA<NetworkFailure>());

        final timeoutError = await Result.fromAsync<String>(
          call: () async {
            throw async.TimeoutException('Timed out');
          },
        );
        expect(timeoutError.failureOrNull, isA<TimeoutFailure>());

        final customError = await Result.fromAsync<String>(
          call: () async {
            throw const AuthException(message: 'Invalid session');
          },
          onError: (err, st) => const AuthFailure('Custom auth error'),
        );
        expect(customError.failureOrNull, isA<AuthFailure>());
        expect(
          customError.failureOrNull?.errorMessage,
          equals('Custom auth error'),
        );
      },
    );

    test('Equality and toString work correctly for Success and Error', () {
      const s1 = Result.success('A');
      const s2 = Result.success('A');
      const s3 = Result.success('B');

      expect(s1, equals(s2));
      expect(s1 == s3, isFalse);
      expect(s1.hashCode, equals(s2.hashCode));
      expect(s1.toString(), contains('Result<String>.success(A)'));

      const e1 = Result<String>.error(ServerFailure('Down'));
      const e2 = Result<String>.error(ServerFailure('Down'));
      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));
      expect(e1.toString(), contains('Result<String>.error'));
    });
  });

  group('AppException & Failure Hierarchy', () {
    test('Exceptions and Failures instantiate properly with custom values', () {
      const serverEx = ServerException(message: 'API Down', statusCode: 503);
      expect(serverEx.message, equals('API Down'));
      expect(serverEx.statusCode, equals(503));
      expect(serverEx.toString(), contains('503'));

      const cacheEx = CacheException(message: 'Key not found');
      expect(cacheEx.message, equals('Key not found'));

      const networkEx = NetworkException();
      expect(networkEx.toString(), contains('NetworkException'));

      const parsingEx = ParsingException(message: 'JSON mismatch');
      expect(parsingEx.message, equals('JSON mismatch'));

      const authEx = AuthException(message: 'Token Expired', statusCode: 401);
      expect(authEx.statusCode, equals(401));

      const permEx = PermissionDeniedException(
        permissionName: 'camera',
        message: 'Camera permission required',
      );
      expect(permEx.permissionName, equals('camera'));

      const fileEx = FilePickerException(message: 'File not found');
      expect(fileEx.message, equals('File not found'));

      const timeoutEx = AppTimeoutException(message: 'Took too long');
      expect(timeoutEx.message, equals('Took too long'));

      const cancelEx = CancellationException(message: 'User aborted');
      expect(cancelEx.message, equals('User aborted'));

      const validationEx = ValidationException(
        message: 'Invalid Form',
        errors: {'email': 'Invalid format'},
      );
      expect(validationEx.errors?['email'], equals('Invalid format'));
    });

    test('Failures extract errorMessage and maintain equality', () {
      const f1 = ServerFailure('Fail 1');
      const f2 = ServerFailure('Fail 1');
      const f3 = CacheFailure('Fail 1');

      expect(f1, equals(f2));
      expect(f1 == f3, isFalse);
      expect(f1.errorMessage, equals('Fail 1'));

      const valFailure = ValidationFailure('Invalid form', {
        'code': 'Required',
      });
      expect(valFailure.errors?['code'], equals('Required'));

      const permFailure = PermissionFailure('Storage denied', 'storage');
      expect(permFailure.permissionName, equals('storage'));
    });
  });
}
