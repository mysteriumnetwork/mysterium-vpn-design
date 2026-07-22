import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── NewsCard ─────────────────────────────────────────────────────────────────

/// A single message entry in the news center list (incident, news or offer).
///
/// Shows a category [NewsPill], a relative [timeLabel], a [title] and a
/// [message] preview. When [unread] is true a blue dot precedes the title and
/// the title is rendered in semibold; read cards use a medium title and indent
/// to keep alignment. When [onTap] is set the card is interactive and raises a
/// hover background; with a null [onTap] it is inert (no hover, default cursor).
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

  /// Category glyph shown inside the leading pill (e.g. `UntitledUI.file_06`).
  final IconData categoryIcon;

  /// Category name shown inside the pill (uppercased by [NewsPill]).
  final String categoryLabel;

  /// Message headline. Wraps to at most two lines.
  final String title;

  /// Message preview text. Truncated to two lines.
  final String message;

  /// Relative timestamp shown on the trailing end (e.g. "12min ago").
  final String timeLabel;

  /// Whether the message is unread. Adds the blue dot and a bolder title.
  final bool unread;

  /// Called when the card is tapped. When null the card is non-interactive.
  final VoidCallback? onTap;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  // 14px is an intentional off-scale radius from the design (between the s=12
  // and m=16 tokens), expressed via the radius token API.
  static final _radius = BorderRadius.all(Radius.custom(14));

  bool _hovered = false;

  bool get _interactive => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    final surface = Container(
      decoration: BoxDecoration(
        color: (_hovered && _interactive) ? palette.bgPrimaryHover : palette.bgPrimary,
        borderRadius: _radius,
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
    );

    return MouseRegion(
      cursor: _interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: _interactive ? (_) => setState(() => _hovered = true) : null,
      onExit: _interactive ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(onTap: widget.onTap, child: surface),
    );
  }
}

// ─── Meta row (pill + timestamp) ────────────────────────────────────────────────

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
          NewsPill(icon: categoryIcon, label: categoryLabel, background: palette.bgSidePanel),
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

  /// Diameter of the unread dot.
  static const _dotSize = 10.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final titleStyle = (unread ? theme.textStyles.textMd.semibold : theme.textStyles.textMd.medium)
        .copyWith(color: palette.textPrimary);

    return Row(
      children: [
        // Fixed leading gutter keeps the title aligned whether or not the dot
        // is present; the dot sits inside it when unread.
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
