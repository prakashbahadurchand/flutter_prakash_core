import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// Options controlling image compression.
class ImageCompressOptions {
  /// Output JPEG quality between 0 and 100.
  final int quality;

  /// Maximum width bound (only applied when provided).
  final int? maxWidth;

  /// Maximum height bound (only applied when provided).
  final int? maxHeight;

  const ImageCompressOptions({
    this.quality = 80,
    this.maxWidth,
    this.maxHeight,
  });
}

/// Image picking and compression helper.
class ImageHelper {
  const ImageHelper._();

  static Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) {
    return ImagePicker().pickImage(source: source);
  }

  /// Picks and compresses an image in a single call.
  static Future<File?> pickAndCompress(
    ImageSource source, {
    ImageCompressOptions options = const ImageCompressOptions(),
  }) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return null;
    return compressFile(File(picked.path), options: options);
  }

  /// Compresses a file to JPEG, returning the new file.
  static Future<File?> compressFile(
    File file, {
    ImageCompressOptions options = const ImageCompressOptions(),
  }) async {
    final target = '${file.absolute.path}.compressed.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      target,
      quality: options.quality,
      minWidth: options.maxWidth ?? 1920,
      minHeight: options.maxHeight ?? 1080,
      format: CompressFormat.jpeg,
    );
    return result == null ? null : File(result.path);
  }

  /// Compresses raw bytes.
  static Future<Uint8List> compressBytes(
    Uint8List data, {
    ImageCompressOptions options = const ImageCompressOptions(),
  }) {
    return FlutterImageCompress.compressWithList(
      data,
      quality: options.quality,
      minWidth: options.maxWidth ?? 1920,
      minHeight: options.maxHeight ?? 1080,
      format: CompressFormat.jpeg,
    );
  }
}
