import 'field.dart';
import 'validators.dart';

/// Pre-configured, enterprise-grade form fields with battle-tested validation rules,
/// dynamic labels, and customizable placeholders.
///
/// ### Usage:
/// ```dart
/// class LoginFormState extends FormCubitState {
///   final Field<String> email;
///   final Field<String> password;
///   final Field<bool> rememberMe;
///
///   LoginFormState({
///     Field<String>? email,
///     Field<String>? password,
///     Field<bool>? rememberMe,
///     super.status = FormStatus.initial,
///   })  : email = email ?? Fields.email(),
///         password = password ?? Fields.password(),
///         rememberMe = rememberMe ?? Fields.boolean(initialValue: false, labelText: 'Remember me');
///
///   @override
///   List<Field<dynamic>> get fields => [email, password, rememberMe];
/// }
/// ```
class Fields {
  Fields._();

  /// Pre-configured Email field with optional requirement and format validation.
  static Field<String> email({
    String? labelText = 'Email',
    String? hintText = 'e.g. alex@example.com',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? emailMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.emailRule(emailMessage),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Password field with length, strength, and requirement options.
  static Field<String> password({
    String? labelText = 'Password',
    String? hintText = '••••••••',
    String? helperText,
    String initialValue = '',
    int minLength = 6,
    bool isRequired = true,
    bool strong = false,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? lengthMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        if (strong)
          Validators.strongPasswordRule()
        else
          Validators.minLengthRule(minLength, lengthMessage),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Confirm Password field that verifies matching another password field.
  static Field<String> confirmPassword({
    required dynamic Function() passwordAccessor,
    String? labelText = 'Confirm Password',
    String? hintText = 'Re-enter your password',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? matchMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.matchRule(
          passwordAccessor,
          matchMessage,
          'Password',
        ),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Phone Number field.
  static Field<String> phone({
    String? labelText = 'Phone Number',
    String? hintText = 'e.g. +1 555 123 4567',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? phoneMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.phoneRule(phoneMessage),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Full Name or Person Name field.
  static Field<String> name({
    String? labelText = 'Full Name',
    String? hintText = 'e.g. John Doe',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    int minLength = 2,
    int maxLength = 70,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.minLengthRule(minLength),
        Validators.maxLengthRule(maxLength),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured URL / Website field.
  static Field<String> url({
    String? labelText = 'Website URL',
    String? hintText = 'https://example.com',
    String? helperText,
    String initialValue = '',
    bool isRequired = false,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? urlMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.urlRule(urlMessage),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured OTP / Verification Code field (digits).
  static Field<String> otp({
    int length = 6,
    String? labelText = 'Verification Code',
    String? hintText = '000000',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? exactLengthMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.exactLengthRule(length, exactLengthMessage),
        Validators.integerRule(),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Boolean checkbox / toggle field (e.g., terms agreement).
  static Field<bool> terms({
    String? labelText = 'I agree to the Terms & Conditions',
    String? helperText,
    bool initialValue = false,
    String? errorMessage = 'You must accept the terms to proceed',
    List<Validator> extraValidators = const [],
  }) {
    return Field<bool>(
      value: initialValue,
      labelText: labelText,
      helperText: helperText,
      validators: [
        Validators.mustBeTrueRule(errorMessage),
        ...extraValidators,
      ],
    );
  }

  /// Generic Boolean field for switches and checkboxes.
  static Field<bool> boolean({
    required bool initialValue,
    String? labelText,
    String? helperText,
    List<Validator> validators = const [],
  }) {
    return Field<bool>(
      value: initialValue,
      labelText: labelText,
      helperText: helperText,
      validators: validators,
    );
  }

  /// Pre-configured Numeric / Amount field.
  static Field<num?> number({
    String? labelText = 'Amount',
    String? hintText = '0.00',
    String? helperText,
    num? initialValue,
    num? min,
    num? max,
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
  }) {
    return Field<num?>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.notNullRule(requiredMessage),
        if (min != null) Validators.minValueRule(min),
        if (max != null) Validators.maxValueRule(max),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Date field.
  static Field<DateTime?> date({
    String? labelText = 'Date',
    String? helperText,
    DateTime? initialValue,
    DateTime? minDate,
    DateTime? maxDate,
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
  }) {
    return Field<DateTime?>(
      value: initialValue,
      labelText: labelText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.notNullRule(requiredMessage),
        if (minDate != null) Validators.dateAfterRule(minDate),
        if (maxDate != null) Validators.dateBeforeRule(maxDate),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Credit Card Number field.
  static Field<String> creditCard({
    String? labelText = 'Card Number',
    String? hintText = '4532 •••• •••• ••••',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? cardMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.creditCardRule(cardMessage),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured CVV field for payment cards.
  static Field<String> cvv({
    String? labelText = 'CVV',
    String? hintText = '123',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? cvvMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.cvvRule(cvvMessage),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Postal / ZIP code field.
  static Field<String> zipCode({
    String? labelText = 'Postal / ZIP Code',
    String? hintText = 'e.g. 90210',
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
    String? zipMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        Validators.zipCodeRule(zipMessage),
        ...extraValidators,
      ],
    );
  }

  /// Pre-configured Generic Text field with customizable constraints.
  static Field<String> text({
    required String labelText,
    String? hintText,
    String? helperText,
    String initialValue = '',
    bool isRequired = true,
    int? minLength,
    int? maxLength,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
  }) {
    return Field<String>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.requiredRule(requiredMessage),
        if (minLength != null) Validators.minLengthRule(minLength),
        if (maxLength != null) Validators.maxLengthRule(maxLength),
        ...extraValidators,
      ],
    );
  }

  /// Generic Dropdown or Selection field.
  static Field<T?> select<T>({
    required String labelText,
    String? hintText,
    String? helperText,
    T? initialValue,
    bool isRequired = true,
    List<Validator> extraValidators = const [],
    String? requiredMessage,
  }) {
    return Field<T?>(
      value: initialValue,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      validators: [
        if (isRequired) Validators.notNullRule(requiredMessage),
        ...extraValidators,
      ],
    );
  }
}
