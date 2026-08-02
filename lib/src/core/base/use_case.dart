import 'package:equatable/equatable.dart';
import '../typedefs/typedefs.dart';

/// Base abstract class for asynchronous UseCases in Clean Architecture.
///
/// Returns a [ResultFuture<T>] containing domain failure or success data.
abstract class UseCase<T, Params> {
  const UseCase();

  ResultFuture<T> call(Params params);
}

/// Base abstract class for synchronous UseCases in Clean Architecture.
abstract class UseCaseSync<T, Params> {
  const UseCaseSync();

  ResultSync<T> call(Params params);
}

/// Base abstract class for Stream-based UseCases in Clean Architecture.
abstract class StreamUseCase<T, Params> {
  const StreamUseCase();

  ResultStream<T> call(Params params);
}

/// Represents an empty parameters object for UseCases requiring no input arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
