import 'package:equatable/equatable.dart';
import 'validators.dart';

const Object _sentinel = Object();

/// An immutable, reactive form field with built-in validation, dynamic label
/// and hint inference, callable shorthand mutator, backend error support,
/// and value-equality via [Equatable].
///
/// ### Fluent Builder Usage:
/// ```dart
/// final email = Field(
///   labelText: 'Corporate email',
///   value: '',
///   hintText: 'e.g. alex@company.com',
///   validators: Validators.required().email(),
/// );
///
/// // Shorthand callable update syntax:
/// final updated = email('user@company.com');
/// ```
class Field<T> with Equatable {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final T value;
  final bool isDirty;
  final List<Validator> validators;
  final String? customError;

  const Field({
    required this.value,
    this.labelText,
    this.hintText,
    this.helperText,
    this.isDirty = false,
    this.validators = const [],
    this.customError,
  });

  // ── Shorthand Callable Mutation ───────────────────────────────────────────

  /// Allows concise invocation `state.email(value)` instead of `state.email.update(value)`.
  Field<T> call(T newValue) => update(newValue);

  // ── Validation ────────────────────────────────────────────────────────────

  /// Returns [customError] if set (e.g. from backend), otherwise the first validator error.
  String? get error {
    if (customError != null) return customError;
    for (final validator in validators) {
      final err = validator(value, labelText);
      if (err != null) return err;
    }
    return null;
  }

  /// Whether all validators pass and no custom error is attached.
  bool get isValid => error == null;

  /// Whether the field has been touched (or has a custom error) AND has an error.
  /// Use this to decide when to show error text in the UI.
  bool get hasError => (isDirty || customError != null) && !isValid;

  /// Opposite of [isDirty] — the field has not been touched and has no custom error.
  bool get isPure => !isDirty && customError == null;

  // ── Mutators (return new instances) ───────────────────────────────────────

  /// Updates the value, marks the field as dirty, and clears any previous custom error.
  Field<T> update(T newValue) =>
      copyWith(value: newValue, isDirty: true, customError: null);

  /// Attaches a custom error (e.g., from server response) and marks field as dirty.
  Field<T> setError(String? error) =>
      copyWith(customError: error, isDirty: true);

  /// Resets to pure state without changing its value.
  Field<T> reset() => copyWith(isDirty: false, customError: null);

  /// Marks the field as dirty without changing its value.
  Field<T> makeDirty() => copyWith(isDirty: true);

  /// Creates a copy with optional overrides.
  Field<T> copyWith({
    String? labelText,
    String? hintText,
    String? helperText,
    T? value,
    bool? isDirty,
    List<Validator>? validators,
    Object? customError = _sentinel,
  }) {
    return Field<T>(
      labelText: labelText ?? this.labelText,
      hintText: hintText ?? this.hintText,
      helperText: helperText ?? this.helperText,
      value: value ?? this.value,
      isDirty: isDirty ?? this.isDirty,
      validators: validators ?? this.validators,
      customError: identical(customError, _sentinel)
          ? this.customError
          : customError as String?,
    );
  }

  @override
  List<Object?> get props => [
    labelText,
    hintText,
    helperText,
    value,
    isDirty,
    customError,
  ];
}
