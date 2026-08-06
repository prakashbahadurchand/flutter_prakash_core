import 'package:get_it/get_it.dart';

/// Global Dependency Injection container instance powered by `GetIt`.
final GetIt sl = GetIt.instance;

/// Syntactic sugar for retrieving a registered dependency instance [T].
T inject<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) {
  return sl.get<T>(
    instanceName: instanceName,
    param1: param1,
    param2: param2,
  );
}

/// Unified Dependency Injection Manager for Flutter Prakash.
///
/// Simplifies DI configuration, module registration, and scope resets across apps.
class PrakashDI {
  PrakashDI._();

  /// Reference to the underlying [GetIt] container.
  static GetIt get instance => sl;

  /// Register a lazy singleton instance.
  static void registerLazySingleton<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    if (!sl.isRegistered<T>(instanceName: instanceName)) {
      sl.registerLazySingleton<T>(factoryFunc, instanceName: instanceName);
    }
  }

  /// Register a factory (creates new instance on each call).
  static void registerFactory<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    if (!sl.isRegistered<T>(instanceName: instanceName)) {
      sl.registerFactory<T>(factoryFunc, instanceName: instanceName);
    }
  }

  /// Register a ready-to-use singleton instance.
  static void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
  }) {
    if (!sl.isRegistered<T>(instanceName: instanceName)) {
      sl.registerSingleton<T>(instance, instanceName: instanceName);
    }
  }

  /// Checks if type [T] is registered.
  static bool isRegistered<T extends Object>({String? instanceName}) {
    return sl.isRegistered<T>(instanceName: instanceName);
  }

  /// Resets the DI container (useful for unit tests or user logouts).
  static Future<void> reset({bool dispose = true}) async {
    await sl.reset(dispose: dispose);
  }
}
