import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Enterprise event transformers using RxDart for BLoC event streams.
///
/// ### Usage:
/// ```dart
/// class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
///   SearchBloc() : super(const SearchState()) {
///     on<SearchQueryChanged>(
///       _onQueryChanged,
///       transformer: PrakashEventTransformers.debounce(
///         const Duration(milliseconds: 300),
///       ),
///     );
///   }
/// }
/// ```
class PrakashEventTransformers {
  PrakashEventTransformers._();

  /// Debounce transformer — waits [duration] of silence before processing the event.
  /// Useful for search fields to avoid rapid-fire API calls.
  static EventTransformer<E> debounce<E>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  /// Throttle transformer — processes first event then ignores for [duration].
  /// Useful for button presses to prevent double-tap actions.
  static EventTransformer<E> throttle<E>(Duration duration) {
    return (events, mapper) => events.throttleTime(duration).switchMap(mapper);
  }

  /// Sequential transformer — processes events one at a time in order.
  static EventTransformer<E> sequential<E>() {
    return (events, mapper) => events.asyncExpand(mapper);
  }

  /// Restartable transformer — cancels the previous event handler on new event.
  static EventTransformer<E> restartable<E>() {
    return (events, mapper) => events.switchMap(mapper);
  }
}
