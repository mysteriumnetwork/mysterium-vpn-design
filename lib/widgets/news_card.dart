import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── NewsCard ─────────────────────────────────────────────────────────────────

/// A single message entry in the news-center list — an incident, news item or
/// offer.
///
/// Composes a category [NewsPill] and a relative [timeLabel] on the top row, a
/// [title] headline, and a [message] preview beneath. When [unread] is true a
/// blue dot ([Palette.unreadIndicator]) precedes the title and the title is
/// rendered in semibold; a read card drops the dot, indents the title to keep
/// the text aligned, and uses a medium title weight.
///
/// Hover is handled internally via [MouseRegion]; pass [onTap] to make the card
/// interactive (e.g. to open the full message). The card fills the width of its
/// parent, so constrain it (or place it in a list) to control its size.
///
/// ```dart
/// NewsCard(
///   categoryIcon: UntitledUI.alert_triangle,
///   categoryLabel: 'Incidents',
///   title: 'Investigating slow connections in Germany',
///   message: 'Some residential IPs in Frankfurt are reconnecting more slowly than usual.',
///   timeLabel: '12min ago',
///   unread: true,
///   onTap: () => openMessage(),
/// )
/// ```
class NewsCard extends StatefulWidget {
  const NewsCard({
    required this.categoryIcon,
    required this.categoryLabel,
    required this.title,
    required this.message,
    required this.timeLabel,
    this.unread = false,
    this.onTap,
    super.key,
  });

  /// Category glyph shown inside the leading [NewsPill] (e.g.
  /// `UntitledUI.file_06`).
  final IconData categoryIcon;

  /// Category name shown inside the leading [NewsPill] (uppercased by the pill).
  final String categoryLabel;

  /// Message headline. Wraps to at most two lines, then ellipsizes.
  final String title;

  /// Message preview. Truncated to at most two lines, then ellipsizes.
  final String message;

  /// Relative timestamp shown at the trailing end of the top row
  /// (e.g. "12min ago"). Formatted by the caller.
  final String timeLabel;

  /// Whether the message is unread. Adds the leading blue dot and renders the
  /// title in semibold. Defaults to false.
  final bool unread;

  /// Called when the card is tapped. When null the card is non-interactive.
  final VoidCallback? onTap;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  // 14px is an intentional off-scale radius from the design, sitting between
  // the s (12px) and m (16px) tokens; expressed via the radius token API.
  static final _borderRadius = BorderRadius.all(Radius.custom(14));

  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: _hovered ? palette.bgPrimaryHover : palette.bgPrimary,
        borderRadius: _borderRadius,
        border: Border.all(color: palette.borderQuaternary),
        boxShadow: [
          BoxShadow(color: palette.shadowSm01, blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(
            color: palette.shadowSm02,
            blurRadius: 2,
            spreadRadius: -1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: theme.spacing.lg,
          children: [
            _MetaRow(
              categoryIcon: widget.categoryIcon,
              categoryLabel: widget.categoryLabel,
              timeLabel: widget.timeLabel,
            ),
            _TitleRow(title: widget.title, unread: widget.unread),
            Padding(
              padding: EdgeInsets.only(left: theme.spacing.xl),
              child: Text(
                widget.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.textXs.regular.copyWith(color: palette.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(onTap: widget.onTap, child: surface),
    );
  }
}

// ─── Meta row (category pill + timestamp) ───────────────────────────────────────

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.categoryIcon,
    required this.categoryLabel,
    required this.timeLabel,
  });

  final IconData categoryIcon;
  final String categoryLabel;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    return Padding(
      padding: EdgeInsets.only(left: theme.spacing.xl),
      child: Row(
        spacing: theme.spacing.s,
        children: [
          NewsPill(icon: categoryIcon, label: categoryLabel),
          Expanded(
            child: Text(
              timeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: theme.textStyles.textXs.regular.copyWith(color: palette.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Title row (unread dot + headline) ──────────────────────────────────────────

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.title, required this.unread});

  final String title;
  final bool unread;

  /// Diameter of the unread indicator dot.
  static const _dotSize = 10.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final titleStyle = (unread ? theme.textStyles.textMd.semibold : theme.textStyles.textMd.medium)
        .copyWith(color: palette.textPrimary);

    return Row(
      children: [
        // A fixed leading gutter keeps the title aligned whether or not the dot
        // is shown; when unread the dot sits at the start of the gutter.
        SizedBox(
          width: theme.spacing.xl,
          child: unread
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: _dotSize,
                    height: _dotSize,
                    decoration: const BoxDecoration(
                      color: Palette.unreadIndicator,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        Expanded(
          child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: titleStyle),
        ),
      ],
    );
  }
}
