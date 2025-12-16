import 'package:flutter/material.dart';

class DecoratedIcon extends StatelessWidget {
  const DecoratedIcon({
    required this.icon,
    this.decoration = const IconDecoration(),
    super.key,
  });

  final IconData icon;
  final IconDecoration decoration;

  @override
  Widget build(BuildContext context) => Container(
        padding: decoration.padding,
        decoration: BoxDecoration(
          color: decoration.backgroundColor,
          borderRadius: decoration.borderRadius,
        ),
        child: Icon(
          icon,
          size: decoration.iconSize,
          color: decoration.iconColor,
        ),
      );
}

@immutable
class IconDecoration {
  const IconDecoration({
    this.iconSize = 16,
    this.iconColor,
    this.backgroundColor,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BorderRadius borderRadius;

  @override
  String toString() =>
      'IconDecoration(iconSize: $iconSize, iconColor: $iconColor, backgroundColor: $backgroundColor, padding: $padding, borderRadius: $borderRadius)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is IconDecoration &&
        other.iconSize == iconSize &&
        other.iconColor == iconColor &&
        other.backgroundColor == backgroundColor &&
        other.padding == padding &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      iconSize.hashCode ^
      iconColor.hashCode ^
      backgroundColor.hashCode ^
      padding.hashCode ^
      borderRadius.hashCode;
}
