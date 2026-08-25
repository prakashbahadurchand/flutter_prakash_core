import 'dart:collection';
import 'dart:convert';

/// A function that returns an error message or `null` if valid.
/// Supports dynamic runtime value inspection and contextual [fieldName] / [labelText] interpolation.
typedef Validator = String? Function(dynamic value, [String? fieldName]);

/// Enterprise-grade, reusable, composable field validators with automatic
/// field label interpolation, standalone rules, and fluent builder chaining.
///
/// ### Fluent Builder Usage:
/// ```dart
/// Field(
///   labelText: 'Corporate email',
///   value: '',
///   validators: Validators.required().email(),
/// );
/// ```
class Validators {
  Validators._();

  // ── Fluent Builder Factory Entrypoints ────────────────────────────────────

  static ValidatorChain required([String? customMessage]) =>
      ValidatorChain().required(customMessage);

  static ValidatorChain notEmpty([String? customMessage]) =>
      ValidatorChain().notEmpty(customMessage);

  static ValidatorChain notNull([String? customMessage]) =>
      ValidatorChain().notNull(customMessage);

  static ValidatorChain mustBeTrue([String? customMessage]) =>
      ValidatorChain().mustBeTrue(customMessage);

  static ValidatorChain mustBeFalse([String? customMessage]) =>
      ValidatorChain().mustBeFalse(customMessage);

  static ValidatorChain email([String? customMessage]) =>
      ValidatorChain().email(customMessage);

  static ValidatorChain minLength(int min, [String? customMessage]) =>
      ValidatorChain().minLength(min, customMessage);

  static ValidatorChain maxLength(int max, [String? customMessage]) =>
      ValidatorChain().maxLength(max, customMessage);

  static ValidatorChain exactLength(int length, [String? customMessage]) =>
      ValidatorChain().exactLength(length, customMessage);

  static ValidatorChain phone([String? customMessage]) =>
      ValidatorChain().phone(customMessage);

  static ValidatorChain url([String? customMessage]) =>
      ValidatorChain().url(customMessage);

  static ValidatorChain pattern(Pattern pattern, [String? customMessage]) =>
      ValidatorChain().pattern(pattern, customMessage);

  static ValidatorChain alphanumeric([String? customMessage]) =>
      ValidatorChain().alphanumeric(customMessage);

  static ValidatorChain alpha([String? customMessage]) =>
      ValidatorChain().alpha(customMessage);

  static ValidatorChain numeric([String? customMessage]) =>
      ValidatorChain().numeric(customMessage);

  static ValidatorChain integer([String? customMessage]) =>
      ValidatorChain().integer(customMessage);

  static ValidatorChain minValue(num min, [String? customMessage]) =>
      ValidatorChain().minValue(min, customMessage);

  static ValidatorChain maxValue(num max, [String? customMessage]) =>
      ValidatorChain().maxValue(max, customMessage);

  static ValidatorChain range(num min, num max, [String? customMessage]) =>
      ValidatorChain().range(min, max, customMessage);

  static ValidatorChain positive([String? customMessage]) =>
      ValidatorChain().positive(customMessage);

  static ValidatorChain negative([String? customMessage]) =>
      ValidatorChain().negative(customMessage);

  static ValidatorChain nonZero([String? customMessage]) =>
      ValidatorChain().nonZero(customMessage);

  static ValidatorChain dateAfter(DateTime minDate, [String? customMessage]) =>
      ValidatorChain().dateAfter(minDate, customMessage);

  static ValidatorChain dateBefore(DateTime maxDate, [String? customMessage]) =>
      ValidatorChain().dateBefore(maxDate, customMessage);

  static ValidatorChain dateBetween(
    DateTime start,
    DateTime end, [
    String? customMessage,
  ]) => ValidatorChain().dateBetween(start, end, customMessage);

  static ValidatorChain pastDate([String? customMessage]) =>
      ValidatorChain().pastDate(customMessage);

  static ValidatorChain futureDate([String? customMessage]) =>
      ValidatorChain().futureDate(customMessage);

  static ValidatorChain ageAtLeast(int minYears, [String? customMessage]) =>
      ValidatorChain().ageAtLeast(minYears, customMessage);

  static ValidatorChain match(
    dynamic Function() other, [
    String? customMessage,
    String? otherFieldName,
  ]) => ValidatorChain().match(other, customMessage, otherFieldName);

  static ValidatorChain strongPassword({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecialChar = true,
    String? customMessage,
  }) => ValidatorChain().strongPassword(
    minLength: minLength,
    requireUppercase: requireUppercase,
    requireLowercase: requireLowercase,
    requireDigit: requireDigit,
    requireSpecialChar: requireSpecialChar,
    customMessage: customMessage,
  );

  static ValidatorChain creditCard([String? customMessage]) =>
      ValidatorChain().creditCard(customMessage);

  static ValidatorChain cvv([String? customMessage]) =>
      ValidatorChain().cvv(customMessage);

  static ValidatorChain iban([String? customMessage]) =>
      ValidatorChain().iban(customMessage);

  static ValidatorChain zipCode([String? customMessage]) =>
      ValidatorChain().zipCode(customMessage);

  static ValidatorChain uuid([String? customMessage]) =>
      ValidatorChain().uuid(customMessage);

  static ValidatorChain ipAddress([String? customMessage]) =>
      ValidatorChain().ipAddress(customMessage);

  static ValidatorChain json([String? customMessage]) =>
      ValidatorChain().json(customMessage);

  static ValidatorChain slug([String? customMessage]) =>
      ValidatorChain().slug(customMessage);

  static ValidatorChain builder() => ValidatorChain();

  // ── Standalone Validator Rules ────────────────────────────────────────────

  /// Fails if the value is null, empty string, empty collection, or false.
  static Validator requiredRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      final name = fieldName ?? 'This field';
      final msg = customMessage ?? '$name is required';

      if (value == null) return msg;
      if (value is String && value.trim().isEmpty) return msg;
      if (value is Iterable && value.isEmpty) return msg;
      if (value is Map && value.isEmpty) return msg;
      if (value is bool && value == false) return msg;
      return null;
    };
  }

  /// Fails if string or collection is null or empty.
  static Validator notEmptyRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      final name = fieldName ?? 'This field';
      final msg = customMessage ?? '$name cannot be empty';

      if (value == null) return msg;
      if (value is String && value.trim().isEmpty) return msg;
      if (value is Iterable && value.isEmpty) return msg;
      if (value is Map && value.isEmpty) return msg;
      return null;
    };
  }

  /// Fails if value is null.
  static Validator notNullRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      final name = fieldName ?? 'This field';
      return value == null ? (customMessage ?? '$name cannot be null') : null;
    };
  }

  /// Fails if boolean value is not true (e.g. Terms & Conditions checkboxes).
  static Validator mustBeTrueRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      final name = fieldName ?? 'Terms & Conditions';
      return value == true ? null : (customMessage ?? 'You must accept $name');
    };
  }

  /// Fails if boolean value is not false.
  static Validator mustBeFalseRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      final name = fieldName ?? 'This field';
      return value == false
          ? null
          : (customMessage ?? '$name must be declined');
    };
  }

  /// Validates standard RFC-5322 compliant email format.
  static Validator emailRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'Email';
      final regex = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
      );
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? 'Enter a valid $name address');
    };
  }

  /// Fails if string is shorter than [min] characters.
  static Validator minLengthRule(int min, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString();
      if (str.trim().isEmpty) return null;
      final name = fieldName ?? 'This field';
      return str.length < min
          ? (customMessage ?? '$name must be at least $min characters')
          : null;
    };
  }

  /// Fails if string is longer than [max] characters.
  static Validator maxLengthRule(int max, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString();
      if (str.trim().isEmpty) return null;
      final name = fieldName ?? 'This field';
      return str.length > max
          ? (customMessage ?? '$name cannot exceed $max characters')
          : null;
    };
  }

  /// Fails if string length is not exactly [length].
  static Validator exactLengthRule(int length, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString();
      if (str.trim().isEmpty) return null;
      final name = fieldName ?? 'This field';
      return str.length != length
          ? (customMessage ?? '$name must be exactly $length characters')
          : null;
    };
  }

  /// Validates international and local phone numbers.
  static Validator phoneRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'Phone number';
      final regex = RegExp(r'^\+?[0-9\s\-()]{7,20}$');
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Validates standard HTTP/HTTPS URLs.
  static Validator urlRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'URL';
      final uri = Uri.tryParse(str);
      final isValid =
          uri != null &&
          uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https');
      return isValid ? null : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Fails if string does not match regex [pattern].
  static Validator patternRule(Pattern pattern, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString();
      if (str.trim().isEmpty) return null;
      final name = fieldName ?? 'This field';
      final hasMatch = pattern is RegExp
          ? pattern.hasMatch(str)
          : RegExp(pattern.toString()).hasMatch(str);
      return hasMatch ? null : (customMessage ?? '$name format is invalid');
    };
  }

  /// Fails if string contains non-alphanumeric characters.
  static Validator alphanumericRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'This field';
      final regex = RegExp(r'^[a-zA-Z0-9]+$');
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? '$name can only contain letters and numbers');
    };
  }

  /// Fails if string contains non-alphabetical characters.
  static Validator alphaRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'This field';
      final regex = RegExp(r'^[a-zA-Z\s]+$');
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? '$name can only contain letters');
    };
  }

  /// Enterprise strong password validator checking uppercase, lowercase, digit, and symbols.
  static Validator strongPasswordRule({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecialChar = true,
    String? customMessage,
  }) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'Password';

      if (str.length < minLength) {
        return customMessage ?? '$name must be at least $minLength characters';
      }
      if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(str)) {
        return customMessage ??
            '$name must contain at least one uppercase letter';
      }
      if (requireLowercase && !RegExp(r'[a-z]').hasMatch(str)) {
        return customMessage ??
            '$name must contain at least one lowercase letter';
      }
      if (requireDigit && !RegExp(r'[0-9]').hasMatch(str)) {
        return customMessage ?? '$name must contain at least one number';
      }
      if (requireSpecialChar &&
          !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(str)) {
        return customMessage ??
            '$name must contain at least one special character';
      }
      return null;
    };
  }

  /// Fails if the string cannot be parsed as a numeric value.
  static Validator numericRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'This field';
      return num.tryParse(str) != null
          ? null
          : (customMessage ?? '$name must be a valid number');
    };
  }

  /// Fails if the string cannot be parsed as an integer.
  static Validator integerRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'This field';
      return int.tryParse(str) != null
          ? null
          : (customMessage ?? '$name must be a whole number');
    };
  }

  /// Fails if parsed number is less than [min].
  static Validator minValueRule(num min, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final name = fieldName ?? 'Value';
      num? number;
      if (value is num) number = value;
      if (value is String && value.trim().isNotEmpty) {
        number = num.tryParse(value.trim());
      }

      if (number != null && number < min) {
        return customMessage ?? '$name must be at least $min';
      }
      return null;
    };
  }

  /// Fails if parsed number is greater than [max].
  static Validator maxValueRule(num max, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final name = fieldName ?? 'Value';
      num? number;
      if (value is num) number = value;
      if (value is String && value.trim().isNotEmpty) {
        number = num.tryParse(value.trim());
      }

      if (number != null && number > max) {
        return customMessage ?? '$name cannot exceed $max';
      }
      return null;
    };
  }

  /// Fails if parsed number is not within [min] and [max] range.
  static Validator rangeRule(num min, num max, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final name = fieldName ?? 'Value';
      num? number;
      if (value is num) number = value;
      if (value is String && value.trim().isNotEmpty) {
        number = num.tryParse(value.trim());
      }

      if (number != null && (number < min || number > max)) {
        return customMessage ?? '$name must be between $min and $max';
      }
      return null;
    };
  }

  /// Fails if number is not positive (> 0).
  static Validator positiveRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final name = fieldName ?? 'Value';
      num? number;
      if (value is num) number = value;
      if (value is String && value.trim().isNotEmpty) {
        number = num.tryParse(value.trim());
      }
      if (number != null && number <= 0) {
        return customMessage ?? '$name must be greater than zero';
      }
      return null;
    };
  }

  /// Fails if number is not negative (< 0).
  static Validator negativeRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final name = fieldName ?? 'Value';
      num? number;
      if (value is num) number = value;
      if (value is String && value.trim().isNotEmpty) {
        number = num.tryParse(value.trim());
      }
      if (number != null && number >= 0) {
        return customMessage ?? '$name must be negative';
      }
      return null;
    };
  }

  /// Fails if number is zero.
  static Validator nonZeroRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final name = fieldName ?? 'Value';
      num? number;
      if (value is num) number = value;
      if (value is String && value.trim().isNotEmpty) {
        number = num.tryParse(value.trim());
      }
      if (number != null && number == 0) {
        return customMessage ?? '$name cannot be zero';
      }
      return null;
    };
  }

  /// Fails if date is before or equal to [minDate].
  static Validator dateAfterRule(DateTime minDate, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null || value is! DateTime) return null;
      final name = fieldName ?? 'Date';
      final formattedMin =
          '${minDate.year}-${minDate.month.toString().padLeft(2, '0')}-${minDate.day.toString().padLeft(2, '0')}';
      return value.isAfter(minDate)
          ? null
          : (customMessage ?? '$name must be after $formattedMin');
    };
  }

  /// Fails if date is after or equal to [maxDate].
  static Validator dateBeforeRule(DateTime maxDate, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null || value is! DateTime) return null;
      final name = fieldName ?? 'Date';
      final formattedMax =
          '${maxDate.year}-${maxDate.month.toString().padLeft(2, '0')}-${maxDate.day.toString().padLeft(2, '0')}';
      return value.isBefore(maxDate)
          ? null
          : (customMessage ?? '$name must be before $formattedMax');
    };
  }

  /// Fails if date is not between [start] and [end].
  static Validator dateBetweenRule(
    DateTime start,
    DateTime end, [
    String? customMessage,
  ]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null || value is! DateTime) return null;
      final name = fieldName ?? 'Date';
      final isValid = value.isAfter(start) && value.isBefore(end);
      return isValid
          ? null
          : (customMessage ??
                '$name must be between ${start.toIso8601String().split('T').first} and ${end.toIso8601String().split('T').first}');
    };
  }

  /// Fails if date is in the future.
  static Validator pastDateRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null || value is! DateTime) return null;
      final name = fieldName ?? 'Date';
      return value.isBefore(DateTime.now())
          ? null
          : (customMessage ?? '$name must be in the past');
    };
  }

  /// Fails if date is in the past.
  static Validator futureDateRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null || value is! DateTime) return null;
      final name = fieldName ?? 'Date';
      return value.isAfter(DateTime.now())
          ? null
          : (customMessage ?? '$name must be in the future');
    };
  }

  /// Fails if date of birth indicates age less than [minYears].
  static Validator ageAtLeastRule(int minYears, [String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null || value is! DateTime) return null;
      final now = DateTime.now();
      int age = now.year - value.year;
      if (now.month < value.month ||
          (now.month == value.month && now.day < value.day)) {
        age--;
      }
      return age >= minYears
          ? null
          : (customMessage ?? 'Must be at least $minYears years of age');
    };
  }

  /// Matches the field value against another field getter callback [other].
  static Validator matchRule(
    dynamic Function() other, [
    String? customMessage,
    String? otherFieldName,
  ]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      if (value is String && value.trim().isEmpty) return null;
      final target = other();
      final name = fieldName ?? 'Field';
      final otherName = otherFieldName ?? 'the target value';

      return value == target
          ? null
          : (customMessage ?? '$name does not match $otherName');
    };
  }

  /// Validates credit card number format using standard Luhn's Algorithm.
  static Validator creditCardRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'Credit card number';
      final cleaned = str.replaceAll(RegExp(r'[\s\-]'), '');
      if (cleaned.length < 13 || cleaned.length > 19) {
        return customMessage ?? 'Enter a valid $name';
      }

      int sum = 0;
      bool alternate = false;
      for (int i = cleaned.length - 1; i >= 0; i--) {
        int n = int.tryParse(cleaned[i]) ?? -1;
        if (n == -1) return customMessage ?? 'Enter a valid $name';
        if (alternate) {
          n *= 2;
          if (n > 9) n -= 9;
        }
        sum += n;
        alternate = !alternate;
      }

      return sum % 10 == 0 ? null : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Validates 3-4 digit CVV card code.
  static Validator cvvRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'CVV';
      final regex = RegExp(r'^[0-9]{3,4}$');
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Validates IBAN format.
  static Validator ibanRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim().replaceAll(' ', '');
      if (str.isEmpty) return null;
      final name = fieldName ?? 'IBAN';
      final regex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{4,30}$');
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Validates standard postal / zip code format.
  static Validator zipCodeRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'Zip / Postal code';
      final regex = RegExp(r'^[0-9a-zA-Z\s\-]{3,10}$');
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Validates standard UUID v4 format.
  static Validator uuidRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'UUID';
      final regex = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
      );
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Validates IPv4 or IPv6 format.
  static Validator ipAddressRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'IP address';
      final isIpv4 = RegExp(
        r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$',
      ).hasMatch(str);
      final isIpv6 = RegExp(
        r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$',
      ).hasMatch(str);
      return isIpv4 || isIpv6 ? null : (customMessage ?? 'Enter a valid $name');
    };
  }

  /// Fails if string cannot be parsed as valid JSON.
  static Validator jsonRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'JSON';
      try {
        jsonDecode(str);
        return null;
      } catch (_) {
        return customMessage ?? '$name format is invalid';
      }
    };
  }

  /// Validates URL slug (lowercase letters, numbers, and hyphens).
  static Validator slugRule([String? customMessage]) {
    return (dynamic value, [String? fieldName]) {
      if (value == null) return null;
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      final name = fieldName ?? 'Slug';
      final regex = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
      return regex.hasMatch(str)
          ? null
          : (customMessage ?? '$name format is invalid');
    };
  }

  /// Custom predicate validator.
  static Validator customRule(
    bool Function(dynamic value) predicate,
    String errorMessage,
  ) {
    return (dynamic value, [String? fieldName]) {
      return predicate(value) ? null : errorMessage;
    };
  }

  /// Combines multiple validators in pipeline order, returning the first failing error.
  static Validator compose(List<Validator> validators) {
    return (dynamic value, [String? fieldName]) {
      for (final validator in validators) {
        final error = validator(value, fieldName);
        if (error != null) return error;
      }
      return null;
    };
  }
}

/// A fluent builder chain for validator rules. Extends [ListBase<Validator>] so
/// it IS a `List<Validator>` and can be assigned directly to `validators:`
/// without any `<Type>` arguments and without `.build()`.
class ValidatorChain extends ListBase<Validator> {
  final List<Validator> _rules;

  ValidatorChain([List<Validator>? rules])
    : _rules = List<Validator>.unmodifiable(rules ?? const []);

  @override
  int get length => _rules.length;

  @override
  set length(int newLength) =>
      throw UnsupportedError('ValidatorChain is immutable');

  @override
  Validator operator [](int index) => _rules[index];

  @override
  void operator []=(int index, Validator value) =>
      throw UnsupportedError('ValidatorChain is immutable');

  @override
  void add(Validator element) =>
      throw UnsupportedError('ValidatorChain is immutable');

  // ── Fluent Builder Methods ────────────────────────────────────────────────

  ValidatorChain addRule(Validator validator) =>
      ValidatorChain([..._rules, validator]);

  ValidatorChain required([String? customMessage]) =>
      addRule(Validators.requiredRule(customMessage));

  ValidatorChain notEmpty([String? customMessage]) =>
      addRule(Validators.notEmptyRule(customMessage));

  ValidatorChain notNull([String? customMessage]) =>
      addRule(Validators.notNullRule(customMessage));

  ValidatorChain mustBeTrue([String? customMessage]) =>
      addRule(Validators.mustBeTrueRule(customMessage));

  ValidatorChain mustBeFalse([String? customMessage]) =>
      addRule(Validators.mustBeFalseRule(customMessage));

  ValidatorChain email([String? customMessage]) =>
      addRule(Validators.emailRule(customMessage));

  ValidatorChain minLength(int min, [String? customMessage]) =>
      addRule(Validators.minLengthRule(min, customMessage));

  ValidatorChain maxLength(int max, [String? customMessage]) =>
      addRule(Validators.maxLengthRule(max, customMessage));

  ValidatorChain exactLength(int length, [String? customMessage]) =>
      addRule(Validators.exactLengthRule(length, customMessage));

  ValidatorChain phone([String? customMessage]) =>
      addRule(Validators.phoneRule(customMessage));

  ValidatorChain url([String? customMessage]) =>
      addRule(Validators.urlRule(customMessage));

  ValidatorChain pattern(Pattern pattern, [String? customMessage]) =>
      addRule(Validators.patternRule(pattern, customMessage));

  ValidatorChain alphanumeric([String? customMessage]) =>
      addRule(Validators.alphanumericRule(customMessage));

  ValidatorChain alpha([String? customMessage]) =>
      addRule(Validators.alphaRule(customMessage));

  ValidatorChain strongPassword({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecialChar = true,
    String? customMessage,
  }) => addRule(
    Validators.strongPasswordRule(
      minLength: minLength,
      requireUppercase: requireUppercase,
      requireLowercase: requireLowercase,
      requireDigit: requireDigit,
      requireSpecialChar: requireSpecialChar,
      customMessage: customMessage,
    ),
  );

  ValidatorChain numeric([String? customMessage]) =>
      addRule(Validators.numericRule(customMessage));

  ValidatorChain integer([String? customMessage]) =>
      addRule(Validators.integerRule(customMessage));

  ValidatorChain minValue(num min, [String? customMessage]) =>
      addRule(Validators.minValueRule(min, customMessage));

  ValidatorChain maxValue(num max, [String? customMessage]) =>
      addRule(Validators.maxValueRule(max, customMessage));

  ValidatorChain range(num min, num max, [String? customMessage]) =>
      addRule(Validators.rangeRule(min, max, customMessage));

  ValidatorChain positive([String? customMessage]) =>
      addRule(Validators.positiveRule(customMessage));

  ValidatorChain negative([String? customMessage]) =>
      addRule(Validators.negativeRule(customMessage));

  ValidatorChain nonZero([String? customMessage]) =>
      addRule(Validators.nonZeroRule(customMessage));

  ValidatorChain dateAfter(DateTime minDate, [String? customMessage]) =>
      addRule(Validators.dateAfterRule(minDate, customMessage));

  ValidatorChain dateBefore(DateTime maxDate, [String? customMessage]) =>
      addRule(Validators.dateBeforeRule(maxDate, customMessage));

  ValidatorChain dateBetween(
    DateTime start,
    DateTime end, [
    String? customMessage,
  ]) => addRule(Validators.dateBetweenRule(start, end, customMessage));

  ValidatorChain pastDate([String? customMessage]) =>
      addRule(Validators.pastDateRule(customMessage));

  ValidatorChain futureDate([String? customMessage]) =>
      addRule(Validators.futureDateRule(customMessage));

  ValidatorChain ageAtLeast(int minYears, [String? customMessage]) =>
      addRule(Validators.ageAtLeastRule(minYears, customMessage));

  ValidatorChain match(
    dynamic Function() other, [
    String? customMessage,
    String? otherFieldName,
  ]) => addRule(Validators.matchRule(other, customMessage, otherFieldName));

  ValidatorChain creditCard([String? customMessage]) =>
      addRule(Validators.creditCardRule(customMessage));

  ValidatorChain cvv([String? customMessage]) =>
      addRule(Validators.cvvRule(customMessage));

  ValidatorChain iban([String? customMessage]) =>
      addRule(Validators.ibanRule(customMessage));

  ValidatorChain zipCode([String? customMessage]) =>
      addRule(Validators.zipCodeRule(customMessage));

  ValidatorChain uuid([String? customMessage]) =>
      addRule(Validators.uuidRule(customMessage));

  ValidatorChain ipAddress([String? customMessage]) =>
      addRule(Validators.ipAddressRule(customMessage));

  ValidatorChain json([String? customMessage]) =>
      addRule(Validators.jsonRule(customMessage));

  ValidatorChain slug([String? customMessage]) =>
      addRule(Validators.slugRule(customMessage));

  ValidatorChain custom(
    bool Function(dynamic value) predicate,
    String errorMessage,
  ) => addRule(Validators.customRule(predicate, errorMessage));

  /// Returns unmodifiable list of compiled validators.
  List<Validator> build() => _rules;
}
