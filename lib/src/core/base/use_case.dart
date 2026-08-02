import 'package:equatable/equatable.dart';
import 'package:flutter_prakash/src/core/network/result.dart';

abstract class UseCase<T, Params> {
  FutureResult<T> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
