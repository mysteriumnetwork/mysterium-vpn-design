import 'package:flutter/material.dart';

class Spacing extends ThemeExtension<Spacing> {
  const Spacing();

  //  tokens (pixels)
  static const double kNone = 0;
  static const double kXxs = 2;
  static const double kXs = 4;
  static const double kMd = 8;
  static const double kXl = 16;
  static const double k2xl = 20;
  static const double k3xl = 24;
  static const double k4xl = 32;
  static const double k5xl = 40;
  static const double k6xl = 48;
  static const double k7xl = 64;
  static const double k8xl = 80;
  static const double k9xl = 96;
  static const double k10xl = 128;
  static const double k11xl = 160;

  double get none => kNone;

  double get xxs => kXxs;

  double get xs => kXs;

  double get md => kMd;

  double get xl => kXl;

  double get x2l => k2xl;

  double get x3l => k3xl;

  double get x4l => k4xl;

  double get x5l => k5xl;

  double get x6l => k6xl;

  double get x7l => k7xl;

  double get x8l => k8xl;

  double get x9l => k9xl;

  double get x10l => k10xl;

  double get x11l => k11xl;

  @override
  ThemeExtension<Spacing> copyWith() => this;

  @override
  ThemeExtension<Spacing> lerp(
    covariant ThemeExtension<Spacing>? other,
    double t,
  ) =>
      this;
}
