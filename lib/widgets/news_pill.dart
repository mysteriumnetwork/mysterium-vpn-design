import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A small pill-shaped category tag used in the news center.
///
/// Displays an [icon] next to an uppercase [label] on a tinted surface —
/// e.g. a "NEWS", "INCIDENTS" or "OFFERS" chip. Both the icon and the
/// (already localized) label are supplied by the caller; the pill owns the
/// visual style, rendering the label in uppercase.
class NewsPill extends StatelessWidget {
  const NewsPill({required this.icon, required this.label, this.background, super.key});

  /// Leading glyph shown before the label. Rendered at 12px.
  final IconData icon;

  /// Text shown inside the pill. Displayed uppercased on a single line.
  final String label;

  /// Optional surface colour override. Defaults to `palette.bgNewsPill`.
  /// `NewsCard` passes `palette.bgSidePanel` to match its context.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.s, vertical: theme.spacing.xxs),
      decoration: BoxDecoration(
        color: background ?? palette.bgNewsPill,
        borderRadius: BorderRadius.all(theme.radius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing.xs,
        children: [
          Icon(icon, size: 12, color: palette.textTertiary),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
            // The type scale bottoms out at textXs (12px); the design calls for
            // an 11px/16 caption, so override size and line-height here.
            style: theme.textStyles.textXs.semibold.copyWith(
              fontSize: 11,
              height: 16 / 11,
              color: palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
