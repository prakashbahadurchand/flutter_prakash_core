import 'package:equatable/equatable.dart';

sealed class BaseState<T> extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class StateInitial<T> extends BaseState<T> {
  const StateInitial();
}

class StateLoading<T> extends BaseState<T> {
  const StateLoading();
}

class StateSuccess<T> extends BaseState<T> {
  final T data;
  const StateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class StateFailure<T> extends BaseState<T> {
  final String message;
  const StateFailure(this.message);

  @override
  List<Object?> get props => [message];
}
