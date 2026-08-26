import 'dart:convert';

import 'package:flutter/material.dart';

Color generateColorFromStringFull(String input) {
  // Generate a hash code from the input string
  int hashCode = utf8.encode(input).fold(0, (out, value) => 31 * out + value);

  // Use the hash code to generate a color
  Color baseColor = Color(hashCode & 0x00FFFFFF).withValues(alpha: 1.0);

  // Generate a shade 50 variant of the base color
  return generateShadeVariant(baseColor, 0);
}

Color generateShadeVariant(Color baseColor, double factor) {
  final baseRed = (baseColor.r * 255.0).round().clamp(0, 255);
  final baseGreen = (baseColor.g * 255.0).round().clamp(0, 255);
  final baseBlue = (baseColor.b * 255.0).round().clamp(0, 255);
  final baseAlpha = (baseColor.a * 255.0).round().clamp(0, 255);

  int red = (baseRed + (255 - baseRed) * factor).round();
  int green = (baseGreen + (255 - baseGreen) * factor).round();
  int blue = (baseBlue + (255 - baseBlue) * factor).round();

  return Color.fromARGB(
    baseAlpha,
    red.clamp(0, 255),
    green.clamp(0, 255),
    blue.clamp(0, 255),
  );
}

Color generateColorFromString(String input) {
  int hashCode = utf8.encode(input).fold(0, (out, value) => 31 * out + value);

  int red = (hashCode >> 16) & 0xFF;
  int green = (hashCode >> 8) & 0xFF;
  int blue = hashCode & 0xFF;

  int shadeRed = (red + ((255 - red) * 0.85)).round();
  int shadeGreen = (green + ((255 - green) * 0.85)).round();
  int shadeBlue = (blue + ((255 - blue) * 0.85)).round();

  return Color.fromRGBO(shadeRed, shadeGreen, shadeBlue, 1.0);
}
