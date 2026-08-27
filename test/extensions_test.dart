import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/extensions/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions', () {
    test('capitalize', () {
      expect('admin'.capitalize(), equals('Admin'));
      expect('ADMIN'.capitalize(), equals('ADMIN'));
      expect(''.capitalize(), equals(''));
    });

    test('toTitleCase', () {
      expect('user_first_name'.toTitleCase(), equals('User First Name'));
      expect('kebab-case-title'.toTitleCase(), equals('Kebab Case Title'));
      expect(''.toTitleCase(), equals(''));
    });

    test('obscureEmail', () {
      expect('alex@company.com'.obscureEmail(), equals('a***x@company.com'));
      expect('al@company.com'.obscureEmail(), equals('al***@company.com'));
      expect('invalid-email'.obscureEmail(), equals('invalid-email'));
    });

    test('toInitials', () {
      expect('John Doe'.toInitials(), equals('JD'));
      expect('Prakash'.toInitials(), equals('P'));
      expect('   '.toInitials(), equals(''));
      expect('First Middle Last'.toInitials(), equals('FL'));
    });

    test('ifEmpty', () {
      expect(''.ifEmpty('Fallback'), equals('Fallback'));
      expect('Value'.ifEmpty('Fallback'), equals('Value'));
    });

    test('toPrettyJson', () {
      expect('{"name":"Prakash"}'.toPrettyJson(), contains('Pretty JSON'));
      expect('invalid'.toPrettyJson(), equals('invalid'));
    });
  });

  group('StringNullExt & Nepali Unicode Conversion', () {
    test('et default fallback', () {
      String? nullStr;
      expect(nullStr.et(another: 'default'), equals('default'));
      expect('hello'.et(another: 'default'), equals('hello'));
      expect(''.et(another: 'default'), equals('default'));
    });

    test('toNepaliDigits conversion', () {
      expect('1234567890'.toND(), equals('१२३४५६७८९०'));
      expect('2081-05-12'.toNepaliDigits(), equals('२०८१-०५-१२'));
      String? nullStr;
      expect(nullStr.toND(), equals(''));
    });
  });

  group('IntExt (Nepali Digits on int)', () {
    test('int.toNepaliDigits', () {
      expect(0.toND(), equals('०'));
      expect(9841.toND(), equals('९८४१'));
      expect(20810512.toNepaliDigits(), equals('२०८१०५१२'));
    });
  });

  group('DateTimeExtensions', () {
    test('toIsoDateString', () {
      final date = DateTime(2026, 8, 28);
      expect(date.toIsoDateString(), equals('2026-08-28'));
    });

    test('toReadableDate', () {
      final date = DateTime(2026, 8, 28);
      expect(date.toReadableDate(), equals('Aug 28, 2026'));
    });

    test('toTimeAgo', () {
      final now = DateTime.now();
      expect(
        now.subtract(const Duration(seconds: 10)).toTimeAgo(),
        equals('Just now'),
      );
      expect(
        now.subtract(const Duration(minutes: 5)).toTimeAgo(),
        equals('5 minutes ago'),
      );
      expect(
        now.subtract(const Duration(hours: 2)).toTimeAgo(),
        equals('2 hours ago'),
      );
      expect(
        now.subtract(const Duration(days: 3)).toTimeAgo(),
        equals('3 days ago'),
      );
      expect(now.subtract(const Duration(days: 30)).toTimeAgo(), isNotEmpty);
    });

    test('isToday', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      expect(today.isToday, isTrue);
      expect(yesterday.isToday, isFalse);
    });
  });

  group('CollectionExtensions & NullExtension', () {
    test('mapIndexed on Iterable', () {
      final items = ['a', 'b', 'c'];
      final mapped = items.mapIndexed((e, i) => '$i:$e').toList();
      expect(mapped, equals(['0:a', '1:b', '2:c']));
    });

    test('MapDynamicExt & ListDynamicExt pretty print', () {
      final map = {'key': 'value'};
      expect(map.toPrettyJson(), contains('Pretty Map'));

      final list = [1, 2, 3];
      expect(list.toPrettyJson(), contains('Pretty List'));
    });

    test('NullableWidget nullOr and isNull', () {
      String? nullString;
      String? presentString = 'Text';

      expect(nullString.isNull, isTrue);
      expect(presentString.isNull, isFalse);

      expect(nullString.nullOr((v) => Text(v)), isNull);
      expect(presentString.nullOr((v) => Text(v)), isA<Text>());
    });
  });
}
