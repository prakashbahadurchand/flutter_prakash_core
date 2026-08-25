import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_event_cubit.dart';
import 'app_event_state.dart';
import 'app_events.dart';

/// Callback invoked when a specific [AppEvent] [E] is dispatched.
typedef AppEventHandler<E extends AppEvent> =
    void Function(BuildContext context, E event);

/// Generic callback for pattern matching with Dart 3 switch statements.
typedef AppEventRawHandler =
    void Function(BuildContext context, AppEvent event);

/// A strongly-typed event handler registration for [AppEventListener].
class OnEvent<E extends AppEvent> {
  final AppEventHandler<E> handler;

  const OnEvent(this.handler);

  /// Checks whether [event] matches [E] and executes [handler].
  bool handle(BuildContext context, AppEvent event) {
    if (event is E) {
      handler(context, event);
      return true;
    }
    return false;
  }
}

/// A high-performance, zero-boilerplate listener that binds [AppEvent]s
/// to a single [BlocListener] stream subscription.
///
/// ### 🌟 Style 1: Modern Dart 3 Pattern Matching Switch (Ultra-Clean):
/// ```dart
/// AppEventListener(
///   onEvent: (context, event) => switch (event) {
///     ProfileChangedEvent() => context.read<UserCubit>().reload(),
///     ProductLikeEvent(:final payload) => updateStats(payload),
///     CartUpdatedEvent(:final payload) => updateBadge(payload.length),
///     _ => null,
///   },
///   child: const DashboardView(),
/// )
/// ```
///
/// ### 🌟 Style 2: Declarative Handler List:
/// ```dart
/// AppEventListener(
///   events: [
///     OnEvent<ProfileChangedEvent>((context, event) => reload()),
///     OnEvent<ProductLikeEvent>((context, event) => updateStats(event.payload)),
///   ],
///   child: const DashboardView(),
/// )
/// ```
class AppEventListener extends StatelessWidget {
  /// Declarative list of [OnEvent] registrations.
  final List<OnEvent>? events;

  /// Direct pattern-matching callback (ideal for Dart 3 switch statements).
  final AppEventRawHandler? onEvent;

  /// The child widget.
  final Widget child;

  const AppEventListener({
    super.key,
    this.events,
    this.onEvent,
    required this.child,
  }) : assert(
         events != null || onEvent != null,
         'Provide either events list or onEvent callback',
       );

  /// Factory helper for listening to a single event type [E].
  static Widget single<E extends AppEvent>({
    Key? key,
    required AppEventHandler<E> onEvent,
    required Widget child,
  }) {
    return AppEventListener(
      key: key,
      events: [OnEvent<E>(onEvent)],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppEventCubit, AppEventState?>(
      listenWhen: (previous, current) => current != null,
      listener: (context, state) {
        if (state == null) return;
        final event = state.event;

        // 1. Fire direct pattern-matching callback if provided
        onEvent?.call(context, event);

        // 2. Fire matching OnEvent handlers if list is provided
        if (events != null) {
          for (final handler in events!) {
            handler.handle(context, event);
          }
        }
      },
      child: child,
    );
  }
}

/// Fluent widget extensions for declarative, zero-boilerplate composition.
extension AppEventListenerExtension on Widget {
  /// Wraps this widget with a pattern-matching [AppEventListener].
  ///
  /// ```dart
  /// const DashboardView().onAppEventPattern((context, event) => switch (event) {
  ///   ProfileChangedEvent() => reload(),
  ///   ProductLikeEvent(:final payload) => update(payload),
  ///   _ => null,
  /// })
  /// ```
  Widget onAppEventPattern(AppEventRawHandler onEvent) {
    return AppEventListener(onEvent: onEvent, child: this);
  }

  /// Wraps this widget with an [AppEventListener] listening to multiple [OnEvent]s.
  Widget onAppEvents(List<OnEvent> events) {
    return AppEventListener(events: events, child: this);
  }

  /// Wraps this widget with an [AppEventListener] listening to a single event [E].
  Widget onAppEvent<E extends AppEvent>(AppEventHandler<E> onEvent) {
    return AppEventListener.single<E>(onEvent: onEvent, child: this);
  }
}
