import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/di/di_manager.dart';
import 'package:flutter_prakash_core/src/fake_data/fake_data.dart';
import 'package:flutter_prakash_core/src/utilities/color_utilities.dart';
import 'package:flutter_prakash_core/src/utilities/debouncer.dart';
import 'package:flutter_test/flutter_test.dart' hide Fake;

class ServiceA {
  final String name;
  ServiceA([this.name = 'ServiceA']);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Debouncer Utility', () {
    test('Debouncer defers execution until delay passes', () async {
      var callCount = 0;
      final debouncer = Debouncer<void>(
        duration: const Duration(milliseconds: 50),
        action: () => callCount++,
      );

      debouncer();
      debouncer();
      debouncer();

      expect(callCount, equals(0));
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(callCount, equals(1));
    });

    test('Debouncer cancel aborts pending execution', () async {
      var callCount = 0;
      final debouncer = Debouncer<void>(
        duration: const Duration(milliseconds: 50),
        action: () => callCount++,
      );

      debouncer();
      debouncer.cancel();

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(callCount, equals(0));
    });
  });

  group('ColorUtilities', () {
    test('generateColorFromString produces stable non-null color', () {
      final c1 = generateColorFromString('Test User');
      final c2 = generateColorFromString('Test User');
      final c3 = generateColorFromString('Another String');

      expect(c1, equals(c2));
      expect(c1, isA<Color>());
      expect(c3, isA<Color>());
    });

    test('generateColorFromStringFull produces stable Color', () {
      final c1 = generateColorFromStringFull('Softix Info');
      final c2 = generateColorFromStringFull('Softix Info');

      expect(c1, equals(c2));
      expect(c1, isA<Color>());
    });

    test('FpColorUtils static methods produce stable non-null colors', () {
      final c1 = FpColorUtils.generateColorFromString('Test User');
      final c2 = FpColorUtils.generateColorFromString('Test User');
      final full = FpColorUtils.generateColorFromStringFull('Softix Info');
      final shade = FpColorUtils.generateShadeVariant(Colors.blue, 0.5);

      expect(c1, equals(c2));
      expect(c1, isA<Color>());
      expect(full, isA<Color>());
      expect(shade, isA<Color>());
    });
  });

  group('Fake Data Generator', () {
    test('Fake data mocks generate valid strings, numbers and collections', () {
      expect(Fake.fullName, isNotEmpty);
      expect(Fake.firstName, isNotEmpty);
      expect(Fake.lastName, isNotEmpty);
      expect(Fake.email, contains('@'));
      expect(Fake.phoneNumber, isNotEmpty);
      expect(Fake.jobTitle, isNotEmpty);
      expect(Fake.city, isNotEmpty);
      expect(Fake.country, isNotEmpty);
      expect(Fake.address, isNotEmpty);
      expect(Fake.id, isNotEmpty);
      expect(Fake.sentence, isNotEmpty);
      expect(Fake.paragraph, isNotEmpty);
      expect(Fake.boolean, isA<bool>());
      expect(Fake.integer(min: 1, max: 10), inInclusiveRange(1, 10));
      expect(Fake.price(min: 10, max: 100), isA<double>());
      expect(Fake.transparentImageMemory(), isNotEmpty);

      final list = Fake.list((i) => 'Item $i', count: 5);
      expect(list.length, equals(5));
      expect(list.first, equals('Item 0'));
    });
  });

  group('FpDI Dependency Injection Container', () {
    tearDown(() async {
      await FpDI.reset();
    });

    test(
      'FpDI registers and injects singletons, factories and instances',
      () async {
        expect(FpDI.isRegistered<ServiceA>(), isFalse);

        // Lazy singleton
        FpDI.registerLazySingleton<ServiceA>(() => ServiceA('Lazy'));
        expect(FpDI.isRegistered<ServiceA>(), isTrue);
        expect(inject<ServiceA>().name, equals('Lazy'));

        await FpDI.reset();
        expect(FpDI.isRegistered<ServiceA>(), isFalse);

        // Factory
        var count = 0;
        FpDI.registerFactory<ServiceA>(() => ServiceA('Factory ${++count}'));
        expect(inject<ServiceA>().name, equals('Factory 1'));
        expect(inject<ServiceA>().name, equals('Factory 2'));

        await FpDI.reset();

        // Ready singleton instance
        final instance = ServiceA('Singleton');
        FpDI.registerSingleton<ServiceA>(instance);
        expect(inject<ServiceA>(), same(instance));
      },
    );
  });
}
