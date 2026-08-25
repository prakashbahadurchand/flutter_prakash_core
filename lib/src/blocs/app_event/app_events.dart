import 'package:meta/meta.dart';

/// Base contract for all global cross-module application events.
/// [T] is the strongly-typed payload carried by the event.
@immutable
abstract class AppEvent<T> {
  final T? payload;
  const AppEvent([this.payload]);

  @override
  String toString() => '$runtimeType(payload: $payload)';
}

/// Generic untyped event for lightweight signals.
class GenericAppEvent extends AppEvent<dynamic> {
  final String name;
  const GenericAppEvent(this.name, [dynamic payload]) : super(payload);

  @override
  String toString() => 'GenericAppEvent($name, payload: $payload)';
}

/// Profile update signal. Payload: None.
class ProfileChangedEvent extends AppEvent<void> {
  const ProfileChangedEvent();
}

/// Home feed data update signal. Payload: None.
class HomeDataUpdatedEvent extends AppEvent<void> {
  const HomeDataUpdatedEvent();
}

/// Product favorite / like signal. Payload: Product ID (`int`).
class ProductLikeEvent extends AppEvent<int> {
  const ProductLikeEvent(super.productId);
}

/// Shopping cart updated signal. Payload: List of items or IDs.
class CartUpdatedEvent extends AppEvent<List<String>> {
  const CartUpdatedEvent(super.items);
}

/// User authentication state change signal (e.g. login, logout).
class AuthStateChangedEvent extends AppEvent<bool> {
  const AuthStateChangedEvent({required bool isAuthenticated})
    : super(isAuthenticated);
}
