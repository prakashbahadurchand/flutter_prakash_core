import 'package:equatable/equatable.dart';

/// Base class for all BLoC events in Clean Architecture.
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

/// Generic Refresh Event for triggering manual data re-fetching.
class BlocRefreshEvent extends BaseEvent {
  const BlocRefreshEvent();
}

/// Generic Reset Event for restoring BLoC state to initial state.
class BlocResetEvent extends BaseEvent {
  const BlocResetEvent();
}

/// Generic Retry Event for retrying failed operations.
class BlocRetryEvent extends BaseEvent {
  const BlocRetryEvent();
}

/// Generic Parametric Event for passing strongly-typed arguments to BLoC.
class BlocDataEvent<T> extends BaseEvent {
  final T data;

  const BlocDataEvent(this.data);

  @override
  List<Object?> get props => [data];
}
