import 'package:flutter/material.dart';

extension ColorUtils on Color {
  static Color fromHex(String hexColor) {
    final cleanedHex = hexColor.trim().replaceFirst('#', '').toUpperCase();
    if (cleanedHex.length == 6) {
      return Color(int.parse('FF$cleanedHex', radix: 16));
    } else if (cleanedHex.length == 8) {
      return Color(int.parse(cleanedHex, radix: 16));
    } else if (cleanedHex.length == 3) {
      final r = cleanedHex[0] * 2;
      final g = cleanedHex[1] * 2;
      final b = cleanedHex[2] * 2;
      return Color(int.parse('FF$r$g$b', radix: 16));
    } else {
      throw FormatException('Invalid color format: $hexColor');
    }
  }

  String toHex() => '#${toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

  Color getForeground({
    required Color onLight,
    required Color onDark,
  }) {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    return switch (brightness) {
      Brightness.dark => onDark,
      Brightness.light => onLight,
    };
  }
}
