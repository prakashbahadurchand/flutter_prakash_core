import 'dart:convert';

import 'package:flutter/material.dart';

/// Utility class for generating deterministic, harmonious colors and shade variants from text input.
class FpColorUtils {
  FpColorUtils._();

  /// Generates a deterministic [Color] from an input [String].
  static Color generateColorFromStringFull(String input) {
    // Generate a hash code from the input string
    final int hashCode = utf8
        .encode(input)
        .fold(0, (out, value) => 31 * out + value);

    // Use the hash code to generate a base color
    final Color baseColor = Color(hashCode & 0x00FFFFFF).withValues(alpha: 1);

    // Generate a shade 50 variant of the base color
    return generateShadeVariant(baseColor, 0);
  }

  /// Generates a shade variant of a given [baseColor] by interpolating with a [factor].
  static Color generateShadeVariant(Color baseColor, double factor) {
    final baseRed = (baseColor.r * 255.0).round().clamp(0, 255);
    final baseGreen = (baseColor.g * 255.0).round().clamp(0, 255);
    final baseBlue = (baseColor.b * 255.0).round().clamp(0, 255);
    final baseAlpha = (baseColor.a * 255.0).round().clamp(0, 255);

    final int red = (baseRed + (255 - baseRed) * factor).round();
    final int green = (baseGreen + (255 - baseGreen) * factor).round();
    final int blue = (baseBlue + (255 - baseBlue) * factor).round();

    return Color.fromARGB(
      baseAlpha,
      red.clamp(0, 255),
      green.clamp(0, 255),
      blue.clamp(0, 255),
    );
  }

  /// Generates a soft pastel-like [Color] from an input [String].
  static Color generateColorFromString(String input) {
    final int hashCode = utf8
        .encode(input)
        .fold(0, (out, value) => 31 * out + value);

    final int red = (hashCode >> 16) & 0xFF;
    final int green = (hashCode >> 8) & 0xFF;
    final int blue = hashCode & 0xFF;

    final int shadeRed = (red + ((255 - red) * 0.85)).round().clamp(0, 255);
    final int shadeGreen = (green + ((255 - green) * 0.85)).round().clamp(
      0,
      255,
    );
    final int shadeBlue = (blue + ((255 - blue) * 0.85)).round().clamp(0, 255);

    return Color.fromARGB(255, shadeRed, shadeGreen, shadeBlue);
  }
}

// ── Backwards-Compatible Top-Level Functions ──────────────────────────────────

/// Generates a deterministic [Color] from an input [String].
Color generateColorFromStringFull(String input) =>
    FpColorUtils.generateColorFromStringFull(input);

/// Generates a shade variant of a given [baseColor] by interpolating with a [factor].
Color generateShadeVariant(Color baseColor, double factor) =>
    FpColorUtils.generateShadeVariant(baseColor, factor);

/// Generates a soft pastel-like [Color] from an input [String].
Color generateColorFromString(String input) =>
    FpColorUtils.generateColorFromString(input);
