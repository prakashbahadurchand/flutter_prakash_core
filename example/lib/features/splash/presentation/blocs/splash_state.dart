import 'package:flutter_prakash_core_example/features/splash/data/models/splash_init_model.dart';

sealed class SplashState {
  const SplashState();
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashLoading extends SplashState {
  const SplashLoading();
}

final class SplashSuccess extends SplashState {
  final SplashInitModel initModel;

  const SplashSuccess(this.initModel);
}

final class SplashFailure extends SplashState {
  final String message;

  const SplashFailure(this.message);
}
