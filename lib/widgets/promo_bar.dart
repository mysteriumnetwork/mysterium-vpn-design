import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A full-width promotional banner with an optional leading [icon], a
/// centred [text] message, and a trailing chevron when [onTap] is set.
///
/// Padding adapts to screen size (roomier on desktop). When [onTap] is
/// null the trailing chevron is hidden and the banner is non-interactive.
class PromoBar extends StatelessWidget {
  const PromoBar({
    required this.text,
    this.onTap,
    this.icon,
    this.actionIcon = Icons.chevron_right,
    super.key,
  });

  /// Optional leading icon rendered in a 24×24 box.
  final Widget? icon;

  /// Trailing icon shown only when [onTap] is set. Defaults to a chevron.
  final IconData actionIcon;

  /// Promo message (wraps up to 3 lines, then ellipsizes).
  final String text;

  /// Tap handler. When null the banner is non-interactive and the
  /// trailing icon is hidden.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = switch (ScreenType.of(context)) {
      ScreenType.desktop => EdgeInsets.symmetric(
        horizontal: theme.spacing.xl5,
        vertical: theme.spacing.xs,
      ),
      _ => EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.xs),
    };
    return RawMaterialButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: Palette.brand.shade300,
      constraints: const BoxConstraints(minHeight: 40, minWidth: double.infinity),
      child: Padding(
        padding: padding,
        child: Row(
          spacing: theme.spacing.s,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              IconTheme(
                data: IconThemeData(color: Palette.brand.shade700),
                child: SizedBox.square(dimension: 24, child: icon),
              ),
            Expanded(
              child: Text(
                text,
                style: theme.textStyles.textSm.semibold.copyWith(color: Palette.grayLight.shade800),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onTap != null)
              IconButton(
                style: IconButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onTap,
                icon: Icon(actionIcon, color: Palette.grayLight.shade800),
              ),
          ],
        ),
      ),
    );
  }
}
