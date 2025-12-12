import 'package:flutter/material.dart';

class MaterialWrapper extends StatelessWidget {
  const MaterialWrapper({
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.color = Colors.transparent,
    this.clipBehavior = Clip.hardEdge,
    super.key,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final Color color;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        clipBehavior: clipBehavior,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: child,
      );
}
