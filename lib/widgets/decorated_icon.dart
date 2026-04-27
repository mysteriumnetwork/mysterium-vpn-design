import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Radius;

/// An icon rendered inside a coloured, rounded container.
///
/// Used for feature glyphs on cards and list rows. Pass [decoration] to
/// customise size, colours, padding, and corner radius.
class DecoratedIcon extends StatelessWidget {
  const DecoratedIcon({required this.icon, this.decoration = const IconDecoration(), super.key});

  /// Glyph to render inside the container.
  final IconData icon;

  /// Visual overrides for the icon and its container.
  final IconDecoration decoration;

  @override
  Widget build(BuildContext context) => Container(
    padding: decoration.padding,
    decoration: BoxDecoration(
      color: decoration.backgroundColor,
      borderRadius: decoration.borderRadius,
    ),
    child: Icon(icon, size: decoration.iconSize, color: decoration.iconColor),
  );
}

/// Visual overrides for a [DecoratedIcon].
@immutable
class IconDecoration {
  const IconDecoration({
    this.iconSize = 16,
    this.iconColor = Palette.brand,
    this.backgroundColor = Palette.white,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  /// Glyph size in logical pixels.
  final double iconSize;

  /// Glyph colour.
  final Color? iconColor;

  /// Container fill colour.
  final Color? backgroundColor;

  /// Inner padding around the glyph.
  final EdgeInsets? padding;

  /// Container corner radius.
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
