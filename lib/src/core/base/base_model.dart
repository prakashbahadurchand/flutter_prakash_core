import 'package:equatable/equatable.dart';

/// Base model abstraction ensuring all domain models enforce equality comparison
/// and optional JSON serialization/deserialization contracts.
abstract class BaseModel extends Equatable {
  const BaseModel();

  @override
  List<Object?> get props => [];
}
