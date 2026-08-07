import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Type ─────────────────────────────────────────────────────────────────────

/// Trailing-action variants for a [SavedIpCard].
enum SavedIpCardType {
  /// The card shows a heart on the trailing edge — filled when
  /// [SavedIpCard.isFavorite] is true, outline when false. Tapping the heart
  /// triggers [SavedIpCard.onFavoriteTap].
  favorite,

  /// The IP is locked (e.g. requires a plan upgrade) — shows a lock icon on
  /// the trailing edge. The lock itself is not interactive; use
  /// [SavedIpCard.onTap] for the card action.
  locked,
}

// ─── Status ───────────────────────────────────────────────────────────────────

/// State variants for a [SavedIpCard].
///
/// Hover is an internal UI concern handled by the widget via `MouseRegion`.
enum SavedIpCardStatus {
  /// Card is visible and interactive.
  idle,

  /// This IP is the active connection — highlighted (selected) surface,
  /// still interactive.
  connected,

  /// Card is non-interactive: greyed-out surface, muted text and icons.
  /// Combined with [SavedIpCardType.locked] this represents an IP the
  /// current subscription plan doesn't support.
  disabled,
}

// ─── SavedIpCard ──────────────────────────────────────────────────────────────

/// A card row for a saved IP address entry.
///
/// Displays a country [countryIcon], location [name] and [subtitle] on the
/// left, the [ipAddress] with a pill [badgeLabel] (e.g. "Residential IP") in
/// the middle, and a trailing icon driven by [type] — a filled heart for
/// favourites or a lock for locked entries.
///
/// ```dart
/// SavedIpCard(
///   countryIcon: flagWidget,
///   name: 'Albania',
///   subtitle: 'Tirana',
///   ipAddress: '195.285.15.404',
///   badgeLabel: 'Residential IP',
///   type: SavedIpCardType.favorite,
///   onTap: connect,
///   onFavoriteTap: unfavourite,
/// )
/// ```
class SavedIpCard extends StatefulWidget {
  const SavedIpCard({
    required this.countryIcon,
    required this.name,
    required this.subtitle,
    required this.ipAddress,
    required this.badgeLabel,
    this.type = SavedIpCardType.favorite,
    this.status = SavedIpCardStatus.idle,
    this.isFavorite = true,
    this.onTap,
    this.onFavoriteTap,
    this.favoriteSemanticLabel,
    super.key,
  });

  /// Country flag rendered at 24×24 on the leading edge.
  final Widget countryIcon;

  /// Location name (e.g. country), rendered prominently on one line.
  final String name;

  /// Secondary line under [name] (e.g. city).
  final String subtitle;

  /// The saved IP address shown in the trailing column.
  final String ipAddress;

  /// Label for the pill badge under [ipAddress] (e.g. "Residential IP").
  final String badgeLabel;

  /// Which trailing icon the card shows. Defaults to
  /// [SavedIpCardType.favorite].
  final SavedIpCardType type;

  /// Interaction state. Defaults to [SavedIpCardStatus.idle].
  final SavedIpCardStatus status;

  /// Whether the IP is currently favourited. Only affects
  /// [SavedIpCardType.favorite] cards: filled heart when true, outline heart
  /// when false. Defaults to true.
  final bool isFavorite;

  /// Tapping anywhere on the card except the heart. Ignored while
  /// [status] is [SavedIpCardStatus.disabled].
  final VoidCallback? onTap;

  /// Tapping the heart on a [SavedIpCardType.favorite] card.
  ///
  /// Unlike [onTap], this stays active while [status] is
  /// [SavedIpCardStatus.disabled] — a saved entry the user can't connect to
  /// must still be removable. Pass null to make the heart inert.
  final VoidCallback? onFavoriteTap;

  /// Accessibility label for the heart button (e.g. "Remove from
  /// favourites"). The icon-only heart is announced as unlabeled without one.
  final String? favoriteSemanticLabel;

  @override
  State<SavedIpCard> createState() => _SavedIpCardState();
}

class _SavedIpCardState extends State<SavedIpCard> {
  bool _hovered = false;

  bool get _disabled => widget.status == SavedIpCardStatus.disabled;

  Color _bgColor(Palette palette) => switch (widget.status) {
    // Disabled is non-interactive, so it has no hover surface.
    SavedIpCardStatus.disabled => palette.bgSecondaryDisabled,
    SavedIpCardStatus.connected =>
      _hovered ? palette.bgSecondarySelectedHover : palette.bgSecondarySelected,
    SavedIpCardStatus.idle => _hovered ? palette.bgPrimaryHover : palette.bgPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _disabled ? null : widget.onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _bgColor(palette),
            borderRadius: const BorderRadius.all(Radius.kS),
            boxShadow: [
              BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.ms),
            child: Row(
              children: [
                Opacity(
                  opacity: _disabled ? 0.5 : 1.0,
                  child: SizedBox(width: 24, height: 24, child: widget.countryIcon),
                ),
                SizedBox(width: theme.spacing.ms),
                Expanded(
                  child: _TextColumn(
                    name: widget.name,
                    subtitle: widget.subtitle,
                    disabled: _disabled,
                  ),
                ),
                Expanded(
                  child: _IpColumn(
                    ipAddress: widget.ipAddress,
                    badgeLabel: widget.badgeLabel,
                    disabled: _disabled,
                  ),
                ),
                _TrailingIcon(
                  type: widget.type,
                  isFavorite: widget.isFavorite,
                  disabled: _disabled,
                  onFavoriteTap: widget.onFavoriteTap,
                  favoriteSemanticLabel: widget.favoriteSemanticLabel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Text column ──────────────────────────────────────────────────────────────

class _TextColumn extends StatelessWidget {
  const _TextColumn({required this.name, required this.subtitle, required this.disabled});

  final String name;
  final String subtitle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final nameColor = disabled ? palette.textPrimaryDisabled : palette.textPrimary;
    final subtitleColor = disabled ? palette.textPrimaryDisabled : palette.textTertiary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.xs,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textStyles.textMd.semibold.copyWith(color: nameColor),
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textStyles.textXs.regular.copyWith(color: subtitleColor),
        ),
      ],
    );
  }
}

// ─── IP + badge column ────────────────────────────────────────────────────────

class _IpColumn extends StatelessWidget {
  const _IpColumn({required this.ipAddress, required this.badgeLabel, required this.disabled});

  final String ipAddress;
  final String badgeLabel;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final textXs = theme.textStyles.textXs;
    final textColor = disabled ? palette.textPrimaryDisabled : palette.textTertiary;
    return Column(
      // crossAxisAlignment defaults to center: the address and its badge are
      // centred on each other.
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.xs,
      children: [
        Text(
          ipAddress,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textXs.regular.copyWith(color: textColor),
        ),
        // DecoratedBox + Padding (not Container) so the 1 px border overlaps
        // the padding like Figma's inside stroke — total height stays 20 px.
        DecoratedBox(
          decoration: BoxDecoration(
            color: disabled ? palette.bgSecondaryDisabled : palette.bgPrimary,
            borderRadius: const BorderRadius.all(Radius.kFull),
            border: Border.all(color: palette.borderPrimary),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.s, vertical: theme.spacing.xxs),
            child: Text(
              badgeLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textXs.medium.copyWith(color: textColor),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Trailing icon ────────────────────────────────────────────────────────────

/// Interaction-overlay alphas for the heart. The overlay is painted directly
/// (not via Material ink, which needs a Material ancestor the card can't
/// assume), so it is a flat fill and needs a touch more opacity to read.
const _overlayPressedAlpha = 0.24;
const _overlayHoveredAlpha = 0.16;

/// Tap target around the 24 px heart glyph.
const _heartTapSize = 32.0;

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({
    required this.type,
    required this.isFavorite,
    required this.disabled,
    this.onFavoriteTap,
    this.favoriteSemanticLabel,
  });

  final SavedIpCardType type;
  final bool isFavorite;
  final bool disabled;
  final VoidCallback? onFavoriteTap;
  final String? favoriteSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    return switch (type) {
      // The heart stays actionable even on a disabled card: an entry the user
      // can no longer connect to (e.g. an unavailable IP) must still be
      // removable. Pass a null [onFavoriteTap] to make it inert.
      SavedIpCardType.favorite => _FavoriteHeart(
        isFavorite: isFavorite,
        color: disabled ? palette.iconDisabled : palette.iconPrimary,
        onTap: onFavoriteTap,
        semanticLabel: favoriteSemanticLabel,
      ),
      SavedIpCardType.locked => Icon(
        UntitledUI.lock_01,
        size: 24,
        color: disabled ? palette.iconDisabled : palette.textTertiary,
      ),
    };
  }
}

/// The heart action on a [SavedIpCardType.favorite] card.
///
/// Paints its own hover / pressed overlay so the feedback works wherever the
/// card is placed, and keeps a [_heartTapSize] target around the glyph.
class _FavoriteHeart extends StatefulWidget {
  const _FavoriteHeart({
    required this.isFavorite,
    required this.color,
    this.onTap,
    this.semanticLabel,
  });

  final bool isFavorite;
  final Color color;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<_FavoriteHeart> createState() => _FavoriteHeartState();
}

class _FavoriteHeartState extends State<_FavoriteHeart> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _interactive => widget.onTap != null;

  Color? get _overlay {
    if (!_interactive) {
      return null;
    }
    if (_pressed) {
      return widget.color.withValues(alpha: _overlayPressedAlpha);
    }
    return _hovered ? widget.color.withValues(alpha: _overlayHoveredAlpha) : null;
  }

  void _setPressed({required bool value}) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) => Semantics(
    button: _interactive,
    enabled: _interactive,
    label: widget.semanticLabel,
    child: MouseRegion(
      cursor: _interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: _interactive ? (_) => _setPressed(value: true) : null,
        onTapUp: _interactive ? (_) => _setPressed(value: false) : null,
        onTapCancel: _interactive ? () => _setPressed(value: false) : null,
        child: Container(
          width: _heartTapSize,
          height: _heartTapSize,
          decoration: BoxDecoration(color: _overlay, shape: BoxShape.circle),
          child: Center(
            child: Icon(
              widget.isFavorite ? UntitledUI.heart_filled : UntitledUI.heart,
              size: 24,
              color: widget.color,
            ),
          ),
        ),
      ),
    ),
  );
}
