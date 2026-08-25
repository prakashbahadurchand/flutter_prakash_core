import 'package:flutter_bloc/flutter_bloc.dart';
import '../../loggers/flutter_logger.dart';

/// Enterprise BLoC observer with configurable structured logging.
///
/// ### Usage:
/// ```dart
/// void main() {
///   Bloc.observer = EnterpriseBlocObserver(
///     logEvents: true,
///     logTransitions: false,
///     logChange: false,
///   );
///   runApp(const MyApp());
/// }
/// ```
class EnterpriseBlocObserver extends BlocObserver {
  final bool logEvents;
  final bool logTransitions;
  final bool logChange;

  const EnterpriseBlocObserver({
    this.logEvents = true,
    this.logTransitions = false,
    this.logChange = false,
  });

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (logEvents) {
      logDebug(
        '⚡ ${bloc.runtimeType} → $event',
        tag: 'BLOC_EVENT',
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (logTransitions) {
      logDebug(
        '🔄 ${bloc.runtimeType}\n'
        '   Event: ${transition.event}\n'
        '   From: ${transition.currentState}\n'
        '   To:   ${transition.nextState}',
        tag: 'BLOC_TRANSITION',
      );
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (logChange) {
      logDebug(
        '📝 ${bloc.runtimeType}\n'
        '   From: ${change.currentState}\n'
        '   To:   ${change.nextState}',
        tag: 'BLOC_CHANGE',
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logError(
      '❌ ${bloc.runtimeType} Error: $error',
      tag: 'BLOC_ERROR',
    );
  }
}
