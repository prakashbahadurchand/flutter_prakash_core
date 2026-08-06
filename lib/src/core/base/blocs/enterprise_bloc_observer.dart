import 'package:flutter_bloc/flutter_bloc.dart';
import '../../loggers/flutter_logger.dart';

/// Global enterprise BlocObserver for observing BLoC and Cubit lifecycle events,
/// state transitions, and unhandled errors across the application.
class EnterpriseBlocObserver extends BlocObserver {
  final bool logEvents;
  final bool logTransitions;
  final bool logChange;
  final void Function(Object error, StackTrace stackTrace)? onErrorCallback;

  EnterpriseBlocObserver({
    this.logEvents = true,
    this.logTransitions = true,
    this.logChange = false,
    this.onErrorCallback,
  });

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    FlutterLogger.i('[BLoC Created] ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (logEvents) {
      FlutterLogger.d('[BLoC Event] ${bloc.runtimeType} -> $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (logChange) {
      FlutterLogger.d(
        '[BLoC Change] ${bloc.runtimeType}: ${change.currentState} -> ${change.nextState}',
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (logTransitions) {
      FlutterLogger.d(
        '[BLoC Transition] ${bloc.runtimeType}: Event: ${transition.event} | State: ${transition.currentState} -> ${transition.nextState}',
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    FlutterLogger.e(
      '[BLoC Error] ${bloc.runtimeType} produced error: $error',
      error: error,
      stackTrace: stackTrace,
    );
    onErrorCallback?.call(error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    FlutterLogger.i('[BLoC Closed] ${bloc.runtimeType}');
  }
}
