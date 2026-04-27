import 'package:flutter/material.dart' as material;

class Radius extends material.ThemeExtension<Radius> {
  const Radius();

  static const kNone = material.Radius.zero;
  static const kXxxs = material.Radius.circular(4);
  static const kXxs = material.Radius.circular(6);
  static const kXs = material.Radius.circular(8);
  static const kS = material.Radius.circular(12);
  static const kM = material.Radius.circular(16);
  static const kXl = material.Radius.circular(20);
  static const kXxl = material.Radius.circular(24);
  static const kFull = material.Radius.circular(9999);

  material.Radius get none => kNone;

  material.Radius get xxxs => kXxxs;

  material.Radius get xxs => kXxs;

  material.Radius get s => kS;

  material.Radius get m => kM;

  material.Radius get xl => kXl;

  material.Radius get xxl => kXxl;

  material.Radius get full => kFull;

  /// Creates a custom circular radius with the given [value].
  static material.Radius custom(double value) => material.Radius.circular(value);

  @override
  material.ThemeExtension<Radius> copyWith() => this;

  @override
  material.ThemeExtension<Radius> lerp(
    covariant material.ThemeExtension<Radius>? other,
    double t,
  ) => this;
}
