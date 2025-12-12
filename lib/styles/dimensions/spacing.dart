import 'package:flutter/material.dart';

class Spacing extends ThemeExtension<Spacing> {
  const Spacing();

  double get none => 0; // spacing-none
  double get xxs => 2; // spacing-xxs
  double get xs => 4; // spacing-xs
  double get sm => 6; // spacing-xs
  double get s => 8; // spacing-sm
  double get lg => 12; // spacing-lg
  double get ms => 12; // spacing-ms
  double get md => 16; // spacing-md
  double get xl => 20; // spacing-xl
  double get xl2 => 24; // spacing-2xl
  double get xl3 => 32; // spacing-3xl
  double get xl4 => 40; // spacing-4xl
  double get xl5 => 48; // spacing-5xl
  double get xl6 => 64; // spacing-6xl
  double get xl7 => 80; // spacing-7xl
  double get xl8 => 96; // spacing-8xl
  double get xl9 => 128; // spacing-9xl
  double get xl10 => 128; // spacing-10xl

  @override
  ThemeExtension<Spacing> copyWith() => this;

  @override
  ThemeExtension<Spacing> lerp(
    covariant ThemeExtension<Spacing>? other,
    double t,
  ) =>
      this;
}
