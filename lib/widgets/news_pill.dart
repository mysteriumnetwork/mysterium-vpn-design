import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A small pill-shaped category tag used in the news center.
///
/// Pairs a leading [icon] with a short [label] on a tinted, fully-rounded
/// surface — e.g. an "INCIDENTS", "NEWS" or "OFFERS" chip. Both the icon and
/// the label are supplied by the caller (this is a design-system package, so
/// strings are never localized here); the pill owns only the visual styling
/// and always renders the label in uppercase.
///
/// The categories in the design differ only by their icon and label — not by
/// colour — so there is deliberately no category enum. Callers map their own
/// category to an [icon] / [label] pair (e.g. via a lookup table).
///
/// ```dart
/// NewsPill(icon: UntitledUI.alert_triangle, label: 'Incidents')
/// ```
class NewsPill extends StatelessWidget {
  const NewsPill({required this.icon, required this.label, this.background, super.key});

  /// Leading glyph shown before the label. Rendered at 12px in
  /// [Palette.textTertiary].
  final IconData icon;

  /// Text shown inside the pill. Rendered uppercased on a single line.
  final String label;

  /// Optional surface-colour override. Defaults to `palette.bgSidePanel` — the
  /// subtle surface the pill sits on inside a [NewsCard].
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.s, vertical: theme.spacing.xxs),
      decoration: BoxDecoration(
        color: background ?? palette.bgSidePanel,
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
            // an 11px / 16px caption, so the size and line height are overridden
            // here rather than introducing an off-scale token.
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
