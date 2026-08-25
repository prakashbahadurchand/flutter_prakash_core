import 'package:flutter/material.dart';
import 'app_event_listener.dart';

/// Semantic alias for [AppEventListener] accepting multiple [OnEvent] handlers.
class AppMultiEventListener extends StatelessWidget {
  /// The collection of strongly-typed event handlers to run.
  final List<OnEvent> events;

  /// The child layout component wrapped by this group of listeners.
  final Widget child;

  const AppMultiEventListener({
    super.key,
    required this.events,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppEventListener(events: events, child: child);
  }
}
