import 'package:flutter_prakash/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result<T>', () {
    test('success factory returns Success and exposes data', () {
      final result = Result.success(42);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, 42);
      expect(result.failureOrNull, isNull);
    });

    test('failure factory returns Fail and exposes failure', () {
      const failure = NetworkFailure();
      final result = Result<int>.failure(failure);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, failure);
    });

    test('fold dispatches to the correct branch', () {
      final ok = Result<String>.success('hello');
      final value = ok.fold(
        onSuccess: (data) => data.length,
        onFailure: (f) => -1,
      );
      expect(value, 5);

      final err = Result<String>.failure(const ServerFailure('boom'));
      final errValue = err.fold(
        onSuccess: (data) => data.length,
        onFailure: (f) => f is ServerFailure ? -99 : -1,
      );
      expect(errValue, -99);
    });
  });

  group('StringX', () {
    test('isValidEmail', () {
      expect('user@example.com'.isValidEmail, isTrue);
      expect('not-an-email'.isValidEmail, isFalse);
    });

    test('isValidPhone', () {
      expect('+9779812345678'.isValidPhone, isTrue);
      expect('abc'.isValidPhone, isFalse);
    });

    test('capitalize', () {
      expect('hello'.capitalize(), 'Hello');
      expect(''.capitalize(), '');
    });
  });

  group('AsyncValue<T>', () {
    test('idle state exposes idle and is not active', () {
      const v = AsyncValue<int>.idle();
      expect(v.isIdle, isTrue);
      expect(v.isLoading, isFalse);
      expect(v.valueOrNull, isNull);
      expect(v.errorOrNull, isNull);
    });

    test('data state carries value and flags readiness', () {
      const v = AsyncValue<String>.data('ok');
      expect(v.hasData, isTrue);
      expect(v.valueOrNull, 'ok');
    });

    test('error state carries a Failure', () {
      const v = AsyncValue<int>.error(ServerFailure('boom'));
      expect(v.hasError, isTrue);
      expect(v.errorOrNull, isA<ServerFailure>());
    });

    test('fold builds a single value from the current state', () {
      const data = AsyncValue<String>.data('hi');
      final label = data.fold(
        onIdle: () => 'idle',
        onLoading: () => 'loading',
        onData: (v) => 'data:$v',
        onError: (f) => 'error',
      );
      expect(label, 'data:hi');
    });

    test('toAsyncValue maps a Result to the matching state', () {
      final ok = Result<String>.success('hi').toAsyncValue();
      expect(ok.hasData, isTrue);
      expect(ok.valueOrNull, 'hi');

      final err = Result<String>.failure(const NetworkFailure()).toAsyncValue();
      expect(err.hasError, isTrue);
      expect(err.errorOrNull, isA<NetworkFailure>());
    });
  });
}
