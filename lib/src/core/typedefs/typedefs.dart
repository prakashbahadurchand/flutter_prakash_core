import 'dart:async';
import '../network/failures.dart';
import '../network/result.dart';

/// Common Clean Architecture Type Definitions.

/// Type alias for JSON maps.
typedef JsonMap = Map<String, dynamic>;

/// Type alias for JSON lists.
typedef JsonList = List<Map<String, dynamic>>;

/// Type alias for raw JSON values (Map, List, String, num, bool, null).
typedef JsonValue = dynamic;

/// Type alias for asynchronous operations returning a domain [Result].
/// Example: `ResultFuture<User>` instead of `Future<Result<User>>`
typedef ResultFuture<T> = Future<Result<T>>;

/// Type alias for synchronous operations returning a domain [Result].
/// Example: `ResultSync<User>` instead of `Result<User>`
typedef ResultSync<T> = Result<T>;

/// Type alias for void operations returning a domain [Result].
/// Example: `ResultVoid` instead of `Future<Result<void>>`
typedef ResultVoid = Future<Result<void>>;

/// Type alias for stream operations returning domain [Result] events.
/// Example: `ResultStream<User>` instead of `Stream<Result<User>>`
typedef ResultStream<T> = Stream<Result<T>>;

/// Callback signatures
typedef ActionCallback = void Function();
typedef ValueCallback<T> = void Function(T value);
typedef AsyncValueCallback<T> = Future<void> Function(T value);
typedef Converter<T, R> = R Function(T input);
typedef AsyncConverter<T, R> = Future<R> Function(T input);
typedef FailureCallback = void Function(Failure failure);
typedef JsonDecoder<T> = T Function(JsonMap json);
typedef JsonEncoder<T> = JsonMap Function(T object);
