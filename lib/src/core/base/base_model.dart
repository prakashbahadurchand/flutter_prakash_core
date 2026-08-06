import 'package:equatable/equatable.dart';

/// Base model abstraction ensuring all domain models enforce equality comparison.
///
/// Subclasses should override [props] to specify properties for comparison.
/// When creating immutable copy instances, implement a `copyWith()` method.
abstract class BaseModel extends Equatable {
  const BaseModel();

  @override
  List<Object?> get props => [];
}

/// Optional mixin requiring [toJson] serialization contract for models that persist or transfer JSON data.
mixin JsonSerializableMixin {
  /// Converts the model instance to a [Map<String, dynamic>] JSON object.
  Map<String, dynamic> toJson();
}
