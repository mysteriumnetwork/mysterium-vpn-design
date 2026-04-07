import 'package:flutter/material.dart' as material;

class Radius extends material.ThemeExtension<Radius> {
  const Radius();

  static const kNone = material.Radius.zero;
  static const kXxs = material.Radius.circular(4);
  static const kXs = material.Radius.circular(6);
  static const kS = material.Radius.circular(8);
  static const kM = material.Radius.circular(16);
  static const kXl = material.Radius.circular(24);

  material.Radius get none => kNone;

  material.Radius get xxs => kXxs;

  material.Radius get xs => kXs;

  material.Radius get s => kS;

  material.Radius get m => kM;

  material.Radius get xl => kXl;

  material.Radius get full => const material.Radius.circular(9999);

  /// Creates a custom circular radius with the given [value].
  static material.Radius custom(double value) =>
      material.Radius.circular(value);

  @override
  material.ThemeExtension<Radius> copyWith() => this;

  @override
  material.ThemeExtension<Radius> lerp(
    covariant material.ThemeExtension<Radius>? other,
    double t,
  ) => this;
}
