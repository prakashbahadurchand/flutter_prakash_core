import '../network/result.dart';

/// Abstract Base Repository interface contract for Clean Architecture.
///
/// Provides the [safeCall] helper method to eliminate try/catch boilerplate
/// when invoking remote data sources or local databases.
abstract class BaseRepository {
  const BaseRepository();

  /// Wraps an asynchronous operations [call] in try/catch, automatically mapping exceptions
  /// to domain [Result.error].
  Future<Result<T>> safeCall<T>(Future<T> Function() call) async {
    return Result.fromAsync(call: call);
  }
}
