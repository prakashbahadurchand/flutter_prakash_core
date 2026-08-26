import 'dart:convert';
import 'dart:developer';

/// Ergonomic convenience extensions on [String].
extension StringExtensions on String {
  /// Capitalizes the first letter of the string (e.g. `'admin'` -> `'Admin'`).
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Converts snake_case or kebab-case into Title Case.
  String toTitleCase() {
    if (isEmpty) return this;
    return replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word.capitalize())
        .join(' ');
  }

  /// Obscures an email address for privacy (e.g. `'alex@company.com'` -> `'a***x@company.com'`).
  String obscureEmail() {
    final parts = split('@');
    if (parts.length != 2) return this;
    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 2) {
      return '$name***@$domain';
    }
    return '${name[0]}***${name[name.length - 1]}@$domain';
  }

  /// Returns user initials (up to 2 characters, e.g. `'John Doe'` -> `'JD'`).
  String toInitials() {
    if (trim().isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }

  String ifEmpty(String another) => isEmpty ? another : this;

  String toPrettyJson() {
    return "\n${"=" * 100}\n|| Pretty List ||:\n${"-" * 100}\n${const JsonEncoder.withIndent("\t").convert(jsonDecode(this))}\n${"-" * 100}\n";
  }

  void toPrintPrettyJson() {
    try {
      log(toPrettyJson());
    } catch (e) {
      log("$e | $this");
    }
  }
}

extension StringNullExt on String? {
  // Replace with anotherText if null or empty
  String et({String another = ""}) => this ?? another;

  static final List<String> arabicNumbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
  static final List<String> nepaliUnicodeNumbers = [
    '०',
    '१',
    '२',
    '३',
    '४',
    '५',
    '६',
    '७',
    '८',
    '९',
  ];

  String toND() => toNepaliDigits();

  String toNepaliDigits() {
    if (this == null || this?.isEmpty == true) return "";

    final arabicNumberString = toString();
    final StringBuffer nepaliUnicodeNumber = StringBuffer();

    for (int i = 0; i < arabicNumberString.length; i++) {
      final index = arabicNumbers.indexOf(arabicNumberString[i]);
      if (index != -1) {
        nepaliUnicodeNumber.write(nepaliUnicodeNumbers[index]);
      } else {
        nepaliUnicodeNumber.write(arabicNumberString[i]);
      }
    }
    return nepaliUnicodeNumber.toString();
  }
}
