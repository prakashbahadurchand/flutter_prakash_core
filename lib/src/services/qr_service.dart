import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// QR code generation helpers.
class QRService {
  const QRService._();

  /// Builds a [QrImageView] widget for [data].
  static Widget render(
    String data, {
    Color color = Colors.black,
    Color backgroundColor = Colors.white,
    double size = 180,
  }) {
    return QrImageView(
      data: data,
      size: size,
      backgroundColor: backgroundColor,
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: color),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: color,
      ),
    );
  }
}
