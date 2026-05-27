import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Visual shape of a [ProgressBar].
enum ProgressBarType {
  /// Horizontal bar with rounded corners.
  linear,

  /// Circular ring indicator.
  circular,
}

/// A themed progress indicator that supports linear and circular layouts.
///
/// For a simple loading spinner without progress, use [LoadingIndicator] instead.
///
/// Use [ProgressBar.linear] or [ProgressBar.circular] when the shape is fixed,
/// or pass [type] directly for a single configurable widget. Indeterminate
/// mode (`value: null`) is only available on the main constructor.
///
/// [value] is a fraction between `0` and `1`. When `null`, the indicator is
/// indeterminate. On iOS and macOS an indeterminate bar renders a
/// [CupertinoActivityIndicator]; on other platforms it uses Material
/// progress indicators.
///
/// [width] and [height] constrain the outer [SizedBox]. For circular
/// indeterminate indicators on Apple platforms, the Cupertino radius is derived
/// from `width ?? height` (default radius `10`).
///
/// [backgroundColor] and [color] override theme defaults. When omitted, colors
/// are taken from the current [Palette].
///
/// ```dart
/// ProgressBar.linear(value: 0.6, width: 200)
/// ProgressBar.circular(value: 0.3, width: 48, height: 48)
/// ```
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.type,
    this.value,
    this.width,
    this.height,
    this.backgroundColor,
    this.color,
    super.key,
  });

  /// Creates a linear [ProgressBar] with a determinate [value].
  factory ProgressBar.linear({
    required double value,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? color,
  }) => ProgressBar(
    type: ProgressBarType.linear,
    value: value,
    width: width,
    height: height,
    backgroundColor: backgroundColor,
    color: color,
  );

  /// Creates a circular [ProgressBar] with a determinate [value].
  factory ProgressBar.circular({
    required double value,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? color,
  }) => ProgressBar(
    type: ProgressBarType.circular,
    value: value,
    width: width,
    height: height,
    backgroundColor: backgroundColor,
    color: color,
  );

  /// Whether the bar is drawn horizontally or as a ring.
  final ProgressBarType type;

  /// Completion fraction (`0`–`1`). `null` renders an indeterminate spinner.
  final double? value;

  /// Optional width of the outer box.
  final double? width;

  /// Optional height of the outer box.
  final double? height;

  /// Track/background fill. Falls back to theme-derived palette colors.
  final Color? backgroundColor;

  /// Foreground/progress fill. Defaults to [Palette.iconBrandSecondary].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    final platform = theme.platform;
    if (value == null && (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)) {
      final size = width ?? height;
      return CupertinoActivityIndicator(
        radius: size != null ? size / 2 : 10,
        color: color ?? palette.iconPrimary,
      );
    }

    final bgColor = _getBackgroundColor(theme: theme, palette: palette);
    final fgColor = _getForegroundColor(palette: palette);

    return SizedBox(
      width: width,
      height: height,
      child: type == ProgressBarType.linear
          ? LinearProgressIndicator(
              value: value,
              backgroundColor: bgColor,
              color: fgColor,
              borderRadius: const BorderRadius.all(Radius.kXxxs),
            )
          : CircularProgressIndicator(value: value, backgroundColor: bgColor, color: fgColor),
    );
  }

  Color _getBackgroundColor({required ThemeData theme, required Palette palette}) {
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    return theme.brightness == Brightness.dark
        ? palette.bgTertiary
        : Palette.grayPurple.shade700;
  }

  Color _getForegroundColor({required Palette palette}) {
    if (color != null) {
      return color!;
    }

    return palette.iconBrandSecondary;
  }
}
