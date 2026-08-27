import 'package:equatable/equatable.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/auth_user_model.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  final AuthUserModel user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}
