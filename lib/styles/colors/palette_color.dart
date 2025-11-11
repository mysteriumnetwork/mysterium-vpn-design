import 'package:flutter/material.dart';

class PaletteColor extends MaterialColor {
  const PaletteColor(super.primary, super.swatch);

  factory PaletteColor.mapped({
    required Color shade25,
    required Color shade50,
    required Color shade100,
    required Color shade200,
    required Color shade300,
    required Color shade400,
    required Color shade500,
    required Color shade600,
    required Color shade700,
    required Color shade800,
    required Color shade900,
    required Color shade950,
  }) =>
      PaletteColor(shade500.toARGB32(), {
        25: shade25,
        50: shade50,
        100: shade100,
        200: shade200,
        300: shade300,
        400: shade400,
        500: shade500,
        600: shade600,
        700: shade700,
        800: shade800,
        900: shade900,
        950: shade950,
      });

  Color get shade25 => this[25]!;

  Color get shade950 => this[950]!;
}
