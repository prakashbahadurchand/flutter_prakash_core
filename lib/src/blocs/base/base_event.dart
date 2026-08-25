import 'package:equatable/equatable.dart';

/// Abstract base event for all BLoC events in clean architecture.
///
/// Provides value-equality via [Equatable] and a `const` constructor.
///
/// ```dart
/// abstract class AuthEvent extends BaseEvent {
///   const AuthEvent();
/// }
///
/// class LoginSubmitted extends AuthEvent {
///   final String email;
///   final String password;
///   const LoginSubmitted({required this.email, required this.password});
///
///   @override
///   List<Object?> get props => [email, password];
/// }
/// ```
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}
