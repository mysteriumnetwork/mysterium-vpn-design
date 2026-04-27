import 'package:flutter/material.dart';

/// A compact [IconButton] preconfigured with zero padding, shrink-wrapped
/// tap target, and [VisualDensity.compact].
///
/// Prefer this over Material's [IconButton] anywhere we need tight-fitting
/// icon controls (toolbars, inline actions). All layout knobs are still
/// overridable.
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.padding,
    this.minimumSize,
    this.tapTargetSize,
    this.visualDensity,
    super.key,
  });

  /// Tap handler. Pass `null` to disable.
  final VoidCallback? onPressed;

  /// Icon widget to render.
  final Widget icon;

  /// Long-press tooltip / a11y label.
  final String? tooltip;

  /// Overrides the default zero padding.
  final EdgeInsetsGeometry? padding;

  /// Overrides the default [Size.zero] minimum size.
  final Size? minimumSize;

  /// Overrides the default [MaterialTapTargetSize.shrinkWrap].
  final MaterialTapTargetSize? tapTargetSize;

  /// Overrides the default [VisualDensity.compact].
  final VisualDensity? visualDensity;
  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    icon: icon,
    tooltip: tooltip,
    style: IconButton.styleFrom(
      padding: padding ?? EdgeInsets.zero,
      minimumSize: minimumSize ?? Size.zero,
      tapTargetSize: tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      visualDensity: visualDensity ?? VisualDensity.compact,
    ),
  );
}
