import 'package:flutter/material.dart';

class Spacing extends ThemeExtension<Spacing> {
  const Spacing();

  /// spacing-none (0px)
  double get none => 0;

  /// spacing-xxs (2px)
  double get xxs => 2;

  /// spacing-xs (4px)
  double get xs => 4;

  /// spacing-sm (6px)
  double get sm => 6;

  /// spacing-s (8px)
  double get s => 8;

  /// spacing-lg (10px)
  double get lg => 10;

  /// spacing-ms (12px)
  double get ms => 12;

  /// spacing-md (16px)
  double get md => 16;

  /// spacing-xl (20px)
  double get xl => 20;

  /// spacing-2xl (24px)
  double get xl2 => 24;

  /// spacing-3xl (32px)
  double get xl3 => 32;

  /// spacing-4xl (40px)
  double get xl4 => 40;

  /// spacing-5xl (48px)
  double get xl5 => 48;

  /// spacing-6xl (64px)
  double get xl6 => 64;

  /// spacing-7xl (80px)
  double get xl7 => 80;

  /// spacing-8xl (96px)
  double get xl8 => 96;

  /// spacing-9xl (128px)
  double get xl9 => 128;

  /// spacing-10xl (128px)
  double get xl10 => 128;

  @override
  ThemeExtension<Spacing> copyWith() => this;

  @override
  ThemeExtension<Spacing> lerp(covariant ThemeExtension<Spacing>? other, double t) => this;
}
