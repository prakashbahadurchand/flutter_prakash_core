import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Pre-built RxDart event transformers for BLoCs.
///
/// Reduces boilerplate when writing reactive BLoC event handlers requiring:
/// - Search input debouncing
/// - Button click throttling
/// - Event cancellation (restartable)
/// - Event dropping (droppable / anti-spam)
abstract class PrakashEventTransformers {
  /// Debounce events by [duration].
  /// Useful for live search inputs or autocompletion to reduce API calls.
  static EventTransformer<E> debounce<E>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  /// Throttle events by [duration].
  /// Ignores new incoming events during the specified window.
  static EventTransformer<E> throttle<E>(Duration duration) {
    return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
  }

  /// Restarts execution whenever a new event is emitted, cancelling the previous inner stream.
  /// Ideal for search queries where previous pending requests should be aborted on new query typing.
  static EventTransformer<E> restartable<E>() {
    return (events, mapper) => events.switchMap(mapper);
  }

  /// Drops new events while the previous event is still processing.
  /// Prevents duplicate form submissions or double tap actions.
  static EventTransformer<E> droppable<E>() {
    return (events, mapper) => events.exhaustMap(mapper);
  }

  /// Process events sequentially, one after another (default BLoC behavior).
  static EventTransformer<E> sequential<E>() {
    return (events, mapper) => events.asyncExpand(mapper);
  }

  /// Process events concurrently in parallel.
  static EventTransformer<E> concurrent<E>() {
    return (events, mapper) => events.flatMap(mapper);
  }
}
