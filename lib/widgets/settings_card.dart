import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// ─── Position ─────────────────────────────────────────────────────────────────

/// Position of a settings card within a grouped card list.
///
/// Controls which corners are rounded and whether a bottom separator is drawn.
enum SettingsCardPosition {
  /// The only card in the group — all corners rounded, no border.
  single,

  /// First card in the group — top corners rounded, bottom border.
  top,

  /// Middle card in the group — no rounding, bottom border.
  middle,

  /// Last card in the group — bottom corners rounded, no border.
  bottom,
}

// ─── GroupedCardShell ─────────────────────────────────────────────────────────

/// Shared surface for rows in a grouped card list ([SettingsCard],
/// [DetailCard]): rounds the corners dictated by [position], draws the inner
/// bottom separator, and paints the elevated card background.
///
/// Pass [onTap] to make the whole row tappable. The row then becomes an
/// [InkWell], so hover, press, splash and keyboard focus all come from one
/// source and touch gets the splash that hover alone cannot provide. The ink
/// is clipped to the row's corner rounding and sits above the background but
/// below the separator.
///
/// The overlay is [Palette.bgPrimaryHover] in every state, which assumes the
/// row sits on [Palette.bgPrimary] — true both when the shell paints its own
/// background and when [transparent] hands the surface to a caller that is
/// itself `bgPrimary`. A transparent row on a different surface needs its own
/// overlay, or the ink will be invisible against it.
class GroupedCardShell extends StatelessWidget {
  const GroupedCardShell({
    required this.position,
    required this.minHeight,
    required this.padding,
    required this.child,
    this.transparent = false,
    this.onTap,
    super.key,
  });

  /// Position within the grouped list — controls corner rounding and whether
  /// the bottom separator is drawn.
  final SettingsCardPosition position;

  /// Minimum row height.
  final double minHeight;

  /// Inner padding around [child].
  final EdgeInsetsGeometry padding;

  /// When true the surface is flush (no background or shadow) — used when a
  /// larger panel supplies the background.
  final bool transparent;

  /// Row content.
  final Widget child;

  /// Called when the row is tapped. When `null` the row is inert and shows no
  /// hover, press or focus feedback.
  final VoidCallback? onTap;

  BorderRadius get _borderRadius => switch (position) {
    SettingsCardPosition.single => const BorderRadius.all(Radius.kS),
    SettingsCardPosition.top => const BorderRadius.vertical(top: Radius.kS),
    SettingsCardPosition.middle => BorderRadius.zero,
    SettingsCardPosition.bottom => const BorderRadius.vertical(bottom: Radius.kS),
  };

  bool get _showBottomBorder =>
      position == SettingsCardPosition.top || position == SettingsCardPosition.middle;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;

    Widget surface = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(padding: padding, child: child),
    );

    // Only interactive rows get a Material. It supplies the ink layer and
    // paints the background so the ink lands above it; a read-only row would
    // carry its elements and implicit animations for feedback it never shows.
    if (onTap != null) {
      surface = Material(
        color: transparent ? Palette.transparent : palette.bgPrimary,
        borderRadius: _borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: _borderRadius,
          overlayColor: WidgetStatePropertyAll(palette.bgPrimaryHover),
          child: surface,
        ),
      );
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            // An interactive row's Material already painted the background.
            color: transparent || onTap != null ? null : palette.bgPrimary,
            borderRadius: _borderRadius,
            boxShadow: transparent
                ? null
                : [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
          ),
          child: surface,
        ),
        if (_showBottomBorder)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // Sits above the ink, and a bare ColoredBox would swallow taps.
            child: IgnorePointer(child: Container(height: 1, color: palette.borderQuaternary)),
          ),
      ],
    );
  }
}

// ─── SettingsCard ─────────────────────────────────────────────────────────────

/// A responsive settings row that adapts its visual style to the current
/// [ScreenType].
///
/// On **desktop** (`tablet` breakpoint and above) the card is transparent and
/// flush — designed to sit inside a larger panel that supplies the background.
///
/// On **mobile** the card is a white surface with a drop shadow — designed to
/// float above the page background colour.
///
/// Stack multiple cards and set the correct [position] to form a grouped
/// settings list with rounded ends and inner separators.
///
/// Pass [onTap] when the whole row navigates — the row then tints on hover and
/// while pressed.
///
/// ```dart
/// Column(
///   children: [
///     SettingsCard(
///       icon: Icon(UntitledUI.user_03, size: 20),
///       title: 'Account',
///       position: SettingsCardPosition.top,
///     ),
///     SettingsCard(
///       icon: Icon(UntitledUI.credit_card_01, size: 20),
///       title: 'My plan',
///       position: SettingsCardPosition.bottom,
///       trailing: GestureDetector(
///         onTap: onManage,
///         child: Text('Manage', style: ...),
///       ),
///     ),
///   ],
/// )
/// ```
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.title,
    this.icon,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.badgeText,
    this.badgeType = BadgeType.neutral,
    this.position = SettingsCardPosition.single,
    this.footer,
    this.onTap,
    super.key,
  });

  /// Optional icon displayed in a leading position.
  /// When `null`, the title fills the available space.
  final Widget? icon;

  /// Primary label for the setting.
  final String title;

  /// Optional secondary label shown beneath [title] in tertiary text colour.
  /// Ignored when [subtitleWidget] is provided.
  final String? subtitle;

  /// Optional widget shown beneath [title], replacing [subtitle].
  /// Use for interactive or specially-styled subtitles (e.g. a link).
  final Widget? subtitleWidget;

  /// Optional widget on the trailing end (e.g. a dropdown, text button,
  /// toggle, or chevron).
  final Widget? trailing;

  /// Optional label rendered as a small [AppBadge] beside [title].
  /// When `null`, no badge is shown.
  final String? badgeText;

  /// Colour scheme for the badge. Ignored when [badgeText] is `null`.
  /// Defaults to [BadgeType.neutral].
  final BadgeType badgeType;

  /// Controls which corners are rounded and whether a bottom separator is
  /// drawn. Defaults to [SettingsCardPosition.single].
  final SettingsCardPosition position;

  /// Optional widget rendered below the main row (icon / title / trailing).
  /// When `null`, nothing is shown.
  final Widget? footer;

  /// Called when the row is tapped. Supplying it also gives the row hover and
  /// press feedback; leave it `null` for rows whose only interaction lives in
  /// [trailing] (a toggle or button).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);
    final row = Row(
      spacing: theme.spacing.md,
      children: [
        ?icon,
        Expanded(
          child: _TextColumn(
            title: title,
            subtitle: subtitle,
            subtitleWidget: subtitleWidget,
            badgeText: badgeText,
            badgeType: badgeType,
          ),
        ),
        ?trailing,
      ],
    );
    return GroupedCardShell(
      position: position,
      minHeight: 70,
      transparent: isDesktop,
      onTap: onTap,
      padding: isDesktop
          ? EdgeInsets.symmetric(vertical: theme.spacing.md)
          : EdgeInsets.all(theme.spacing.md),
      child: footer == null
          ? row
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: theme.spacing.s,
              children: [row, footer!],
            ),
    );
  }
}

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _TextColumn extends StatelessWidget {
  const _TextColumn({
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.badgeText,
    this.badgeType = BadgeType.neutral,
  });

  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final String? badgeText;
  final BadgeType badgeType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: theme.spacing.xxs,
      children: [
        Row(
          spacing: theme.spacing.md,
          children: [
            Flexible(
              child: Text(
                title,
                style: theme.textStyles.textMd.regular.copyWith(color: palette.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (badgeText != null)
              AppBadge(text: badgeText!, type: badgeType, size: BadgeSize.small),
          ],
        ),
        if (subtitleWidget != null)
          subtitleWidget!
        else if (subtitle != null)
          Text(
            subtitle!,
            style: theme.textStyles.textXs.regular.copyWith(color: palette.textTertiary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
