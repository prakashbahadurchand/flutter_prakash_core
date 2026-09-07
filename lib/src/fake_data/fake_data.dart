import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:faker/faker.dart' as f;
import 'package:flutter/material.dart';

/// A comprehensive, full-featured fake data generator utility (`Fake`) designed for
/// unit testing, widget testing, mock models, UI placeholders, network simulation,
/// and in-memory/disk temporary image and file creation.
///
/// Usage Example:
/// ```dart
/// import 'package:flutter_prakash_core/fp_core.dart';
///
/// // 1. Mock User Data & Profiles
/// final name = Fake.fullName;
/// final email = Fake.email;
/// final avatar = Fake.avatarUrl();
/// final bio = Fake.paragraph;
/// final socials = Fake.socialLink('github');
///
/// // 2. Mock Media & Files
/// final placeholderUrl = Fake.imageUrl(width: 600, height: 400);
/// final memoryBytes = await Fake.imageMemory(color: Colors.red);
/// final transparentBytes = Fake.transparentImageMemory();
/// final tempFile = await Fake.imageFile(filename: 'profile.png');
///
/// // 3. Mock Collections & Lists
/// final mockUsers = Fake.list((i) => {
///   'id': Fake.id,
///   'name': Fake.fullName,
///   'email': Fake.email,
///   'price': Fake.price(min: 10, max: 99),
/// }, count: 5);
/// ```
class Fake {
  Fake._();

  static final f.Faker _faker = f.Faker();

  // ===========================================================================
  // 1. IMAGES & MEDIA MOCKS
  // ===========================================================================

  /// Generates a placeholder image URL using Unsplash or Picsum.
  static String imageUrl({
    int width = 400,
    int height = 400,
    String? category,
    int? seed,
  }) {
    if (seed != null) {
      return 'https://picsum.photos/seed/$seed/$width/$height';
    }
    if (category != null && category.isNotEmpty) {
      return 'https://images.unsplash.com/photo-1500000000000?auto=format&fit=crop&w=$width&h=$height&q=80&keywords=$category';
    }
    return 'https://picsum.photos/id/${_faker.randomGenerator.integer(1000)}/$width/$height';
  }

  /// Generates an avatar image URL.
  static String avatarUrl({int size = 200, String? gender}) {
    final id = _faker.randomGenerator.integer(99);
    final selectedGender =
        gender?.toLowerCase() ??
        (_faker.randomGenerator.boolean() ? 'men' : 'women');
    return 'https://randomuser.me/api/portraits/$selectedGender/$id.jpg';
  }

  /// Generates raw `Uint8List` image bytes in memory (1x1 transparent PNG or colored PNG).
  static Future<Uint8List> imageMemory({
    int width = 100,
    int height = 100,
    Color color = Colors.blue,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );
    final paint = Paint()..color = color;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      paint,
    );
    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? Uint8List(0);
  }

  /// Synchronously returns tiny 1x1 transparent PNG bytes for mock Image.memory widgets.
  static Uint8List transparentImageMemory() {
    return Uint8List.fromList(<int>[
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG Header
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      0x42, 0x60, 0x82,
    ]);
  }

  /// Creates a temporary image [File] on local disk.
  static Future<File> imageFile({
    String? filename,
    int width = 100,
    int height = 100,
    Color color = Colors.blue,
  }) async {
    final bytes = await imageMemory(width: width, height: height, color: color);
    final tempDir = Directory.systemTemp;
    final file = File(
      '${tempDir.path}/${filename ?? "fake_img_${DateTime.now().millisecondsSinceEpoch}.png"}',
    );
    return file.writeAsBytes(bytes);
  }

  // ===========================================================================
  // 2. USERS, PERSONA & PROFILES
  // ===========================================================================

  /// Generates a fake full name.
  static String get fullName => _faker.person.name();

  /// Generates a fake first name.
  static String get firstName => _faker.person.firstName();

  /// Generates a fake last name.
  static String get lastName => _faker.person.lastName();

  /// Generates a fake email address.
  static String get email => _faker.internet.email();

  /// Generates a fake phone number.
  static String get phoneNumber => _faker.phoneNumber.us();

  /// Generates a fake job title.
  static String get jobTitle => _faker.job.title();

  /// Generates a fake UUID v4.
  static String get id => _faker.guid.guid();

  // ===========================================================================
  // 3. SOCIAL & INTERNET
  // ===========================================================================

  /// Generates a fake social media link (Twitter, GitHub, LinkedIn, Instagram, etc.).
  static String socialLink([String? platform]) {
    final user = _faker.internet.userName();
    final p =
        platform?.toLowerCase() ??
        _faker.randomGenerator.element([
          'github',
          'twitter',
          'linkedin',
          'instagram',
        ]);
    switch (p) {
      case 'github':
        return 'https://github.com/$user';
      case 'twitter':
      case 'x':
        return 'https://x.com/$user';
      case 'linkedin':
        return 'https://linkedin.com/in/$user';
      case 'instagram':
        return 'https://instagram.com/$user';
      default:
        return 'https://$p.com/$user';
    }
  }

  /// Generates a fake website URL.
  static String get url => _faker.internet.httpsUrl();

  /// Generates a fake username.
  static String get username => _faker.internet.userName();

  // ===========================================================================
  // 4. TEXT & CONTENT
  // ===========================================================================

  /// Generates a fake title/sentence.
  static String title([int wordCount = 4]) =>
      _faker.lorem.words(wordCount).join(' ');

  /// Generates a fake paragraph of text.
  static String get paragraph => _faker.lorem.sentences(3).join(' ');

  /// Generates multiple fake paragraphs.
  static List<String> paragraphs([int count = 3]) =>
      List.generate(count, (_) => _faker.lorem.sentences(3).join(' '));

  /// Generates fake sentence text.
  static String get sentence => _faker.lorem.sentence();

  // ===========================================================================
  // 5. LOCATION & ADDRESS
  // ===========================================================================

  /// Generates a fake street address.
  static String get address =>
      '${_faker.address.buildingNumber()} ${_faker.address.streetName()}';

  /// Generates a fake city name.
  static String get city => _faker.address.city();

  /// Generates a fake country.
  static String get country => _faker.address.country();

  /// Generates fake geographical coordinates `(latitude, longitude)`.
  static Map<String, double> get latLng => {
    'latitude': (_faker.randomGenerator.decimal() * 180) - 90, // -90 to +90
    'longitude': (_faker.randomGenerator.decimal() * 360) - 180, // -180 to +180
  };

  // ===========================================================================
  // 6. NUMBERS, DATES & FINANCIAL
  // ===========================================================================

  /// Generates a random integer within [min] and [max].
  static int integer({int min = 0, int max = 100}) {
    return min + _faker.randomGenerator.integer(max - min + 1);
  }

  /// Generates a random double price amount.
  static double price({double min = 5.0, double max = 500.0}) {
    final value = min + (_faker.randomGenerator.decimal() * (max - min));
    return double.parse(value.toStringAsFixed(2));
  }

  /// Generates a fake credit card number.
  static String get creditCardNumber =>
      _faker.randomGenerator.numbers(16, 9).join();

  /// Generates a fake past [DateTime].
  static DateTime pastDate({int maxDaysAgo = 365}) {
    final days = _faker.randomGenerator.integer(maxDaysAgo);
    return DateTime.now().subtract(Duration(days: days));
  }

  /// Generates a fake future [DateTime].
  static DateTime futureDate({int maxDaysAhead = 365}) {
    final days = _faker.randomGenerator.integer(maxDaysAhead);
    return DateTime.now().add(Duration(days: days));
  }

  /// Generates a random boolean.
  static bool get boolean => _faker.randomGenerator.boolean();

  // ===========================================================================
  // 7. COLLECTIONS & UTILITIES
  // ===========================================================================

  /// Returns a list generated by calling [generator] [count] times.
  static List<T> list<T>(T Function(int index) generator, {int count = 10}) {
    return List<T>.generate(count, generator);
  }

  /// Picks a random element from a given [items] list.
  static T element<T>(List<T> items) {
    return _faker.randomGenerator.element(items);
  }
}
