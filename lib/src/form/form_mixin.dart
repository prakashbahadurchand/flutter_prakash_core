import 'field.dart';

/// Mixin that provides form-level validation by combining [Field] instances.
///
/// States that use this mixin must override [formFields] to return all
/// fields participating in form validation.
///
/// ```dart
/// @freezed
/// class LoginState with _$LoginState, FormMixin {
///   // ...
///   @override
///   List<Field<dynamic>> get formFields => [email, password];
/// }
/// ```
mixin FormMixin {
  /// All fields participating in form validation.
  List<Field<dynamic>> get formFields;

  /// Whether every field passes validation.
  bool get isFormValid => formFields.every((field) => field.isValid);

  /// The first validation error across all fields, or `null` if valid.
  String? get firstError =>
      formFields.where((f) => !f.isValid).map((f) => f.error).firstOrNull;

  /// All current validation errors across all fields.
  List<String> get allErrors => formFields
      .where((f) => !f.isValid)
      .map((f) => f.error)
      .whereType<String>()
      .toList();

  /// Number of fields that have been touched.
  int get dirtyFieldCount => formFields.where((f) => f.isDirty).length;

  /// Number of fields that have been touched and have errors.
  int get errorFieldCount => formFields.where((f) => f.hasError).length;
}
