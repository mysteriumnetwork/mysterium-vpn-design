import 'package:flutter/material.dart';

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
  final VoidCallback onPressed;
  final Widget icon;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final MaterialTapTargetSize? tapTargetSize;
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
