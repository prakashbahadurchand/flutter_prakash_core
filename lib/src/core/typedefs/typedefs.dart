import 'dart:async';
import 'package:flutter/material.dart';
import '../network/failures.dart';
import '../network/result.dart';

/// Comprehensive Clean Architecture Type Definitions for Flutter Prakash.

// =============================================================================
// JSON & DATA PIPELINE TYPEDEFS
// =============================================================================

/// Type alias for standard JSON maps (`Map<String, dynamic>`).
typedef JsonMap = Map<String, dynamic>;

/// Type alias for JSON list payloads (`List<Map<String, dynamic>>`).
typedef JsonList = List<Map<String, dynamic>>;

/// Type alias for raw JSON values (primitive types, List, Map, or null).
typedef PrakashJsonValue = dynamic;

/// Decoder function signature to transform a [JsonMap] into a domain/data entity [T].
typedef JsonDecoder<T> = T Function(JsonMap json);

/// Encoder function signature to transform an object instance [T] into a [JsonMap].
typedef JsonEncoder<T> = JsonMap Function(T object);

/// Decoder function signature to transform a [JsonList] into a List of domain/data entities [T].
typedef JsonListDecoder<T> = List<T> Function(JsonList jsonList);

// =============================================================================
// CLEAN ARCHITECTURE RESULT & DOMAIN TYPEDEFS
// =============================================================================

/// Primary Clean Architecture type alias for asynchronous operations returning a domain [Result].
/// Example: `ResultFuture<User>` instead of `Future<Result<User>>`.
typedef ResultFuture<T> = Future<Result<T>>;

/// Type alias for synchronous operations returning a domain [Result].
/// Example: `ResultSync<User>` instead of `Result<User>`.
typedef ResultSync<T> = Result<T>;

/// Type alias for asynchronous operations that perform an action and return `void` inside a domain [Result].
/// Example: `ResultVoid` instead of `Future<Result<void>>`.
typedef ResultVoid = Future<Result<void>>;

/// Type alias for real-time stream operations yielding domain [Result] events over time.
/// Example: `ResultStream<User>` instead of `Stream<Result<User>>`.
typedef ResultStream<T> = Stream<Result<T>>;

// =============================================================================
// FUNCTIONAL CALLBACKS & TRANSFORMER SIGNATURES
// =============================================================================

/// Synchronous void action callback with no arguments.
typedef ActionCallback = void Function();

/// Asynchronous void action callback with no arguments.
typedef AsyncActionCallback = Future<void> Function();

/// Single parameter value callback handler.
typedef ValueCallback<T> = void Function(T value);

/// Asynchronous value callback handler.
typedef AsyncValueCallback<T> = Future<void> Function(T value);

/// Two-parameter value callback handler.
typedef ValuePairCallback<T1, T2> = void Function(T1 first, T2 second);

/// Synchronous data transformer/mapper signature.
typedef Converter<T, R> = R Function(T input);

/// Asynchronous data transformer/mapper signature.
typedef AsyncConverter<T, R> = Future<R> Function(T input);

/// Domain failure notification handler.
typedef FailureCallback = void Function(Failure failure);

/// Predicate function signature returning boolean based on input entity [T].
typedef EntityPredicate<T> = bool Function(T item);

// =============================================================================
// UI & FLUTTER HELPERS
// =============================================================================

/// Dynamic widget builder signature taking a context and typed item.
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

/// Dynamic widget builder signature taking a context, typed item, and item index.
typedef IndexedItemWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

/// Custom error widget builder signature taking BuildContext and domain Failure.
typedef FailureWidgetBuilder = Widget Function(
  BuildContext context,
  Failure failure,
);
