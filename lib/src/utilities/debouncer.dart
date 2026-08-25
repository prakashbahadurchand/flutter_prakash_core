import 'dart:async';

/// Debounces rapid successive invocations, deferring [action] until [duration]
/// has passed without a new call. Ideal for search-as-you-type.
class Debouncer<T> {
  Debouncer({required this.duration, required this.action});

  final Duration duration;
  final FutureOr<void> Function() action;

  Timer? _timer;

  /// Schedules the action, cancelling any previously pending one.
  void call() {
    _timer?.cancel();
    _timer = Timer(duration, () async {
      await action();
    });
  }

  /// Cancels a pending (but not-yet-executed) invocation.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
