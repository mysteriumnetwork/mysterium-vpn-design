import 'package:flutter/material.dart';

enum ProgressBarType {
  /// A progress bar with a linear gradient.
  horizontal,

  /// A progress bar with a circular gradient.
  circular,
}

enum ProgressBarTheme {
  light((foreground: Color(0xFFDA78FA), background: Color(0xFFDFDCEA))),
  dark((foreground: Color(0xFFDA78FA), background: Color(0xFF494068)));

  const ProgressBarTheme(this.colors);

  final ({Color foreground, Color background}) colors;
}

sealed class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.variant, required this.theme, required this.value, super.key});

  final ProgressBarType variant;
  final ProgressBarTheme theme;
  final double? value;
}

class HorizontalProgressBar extends ProgressBar {
  const HorizontalProgressBar({required super.theme, required super.value, super.key})
    : super(variant: ProgressBarType.horizontal);

  @override
  Widget build(BuildContext context) => LinearProgressIndicator(
    borderRadius: BorderRadius.circular(4),
    value: value,
    backgroundColor: theme.colors.background,
    color: theme.colors.foreground,
  );
}

class CircularProgressBar extends ProgressBar {
  const CircularProgressBar({required super.theme, required super.value, super.key})
    : super(variant: ProgressBarType.circular);

  @override
  Widget build(BuildContext context) => CircularProgressIndicator(
    value: value,
    backgroundColor: theme.colors.background,
    color: theme.colors.foreground,
  );
}
