import 'package:meta/meta.dart';
import 'app_events.dart';

/// State wrapper emitted by [AppEventCubit] whenever an [AppEvent] is fired.
@immutable
class AppEventState {
  final AppEvent event;
  final DateTime _timestamp;

  AppEventState(this.event) : _timestamp = DateTime.now();

  /// Overrides equality checking to guarantee that every single time
  /// an event is fired, Bloc recognizes it as a fresh, distinct mutation.
  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => _timestamp.hashCode;

  @override
  String toString() => 'AppEventState(${event.toString()})';
}
