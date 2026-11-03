import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A small pill-shaped label used to tag or annotate content.
///
/// Use [type] to pick a colour scheme (neutral / green / green secondary /
/// warning / error / brand) and [size] for density.
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.text,
    this.type = BadgeType.neutral,
    this.size = BadgeSize.medium,
    this.icon,
    this.tooltip,
    super.key,
  });

  /// Label shown inside the badge. Rendered on a single line.
  final String text;

  /// Colour scheme. Defaults to [BadgeType.neutral].
  final BadgeType type;

  /// Badge density preset. Defaults to [BadgeSize.medium].
  final BadgeSize size;

  /// Optional leading icon, tinted with the badge's text colour and sized to
  /// [size] (12 for [BadgeSize.small], 14 for [BadgeSize.medium]).
  ///
  /// With an icon the horizontal padding tightens from 12 to 8, per the Figma
  /// icon-badge spec, and the label ellipsizes when the badge is given less
  /// room than it needs.
  final IconData? icon;

  /// When set, the badge shows [tooltip] on hover (desktop) and on tap
  /// (mobile). Leave `null` for a purely decorative badge.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final foreground = _getTextColor(palette);

    final label = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
      style: _getTextStyle(theme.textStyles).copyWith(color: foreground),
    );

    final badge = Container(
      padding: _getPadding(theme.spacing),
      decoration: BoxDecoration(
        color: _getBackgroundColor(palette),
        borderRadius: BorderRadius.all(theme.radius.full),
        border: Border.all(color: _getBorderColor(palette)),
      ),
      child: icon == null
          ? label
          : Row(
              mainAxisSize: MainAxisSize.min,
              spacing: theme.spacing.xs,
              children: [
                Icon(icon, size: _iconSize, color: foreground),
                Flexible(child: label),
              ],
            ),
    );

    if (tooltip == null) {
      return badge;
    }

    return Tooltip(
      message: tooltip,
      triggerMode: TooltipTriggerMode.tap,
      mouseCursor: SystemMouseCursors.click,
      textAlign: TextAlign.start,
      child: badge,
    );
  }

  double get _iconSize => switch (size) {
    BadgeSize.small => 12,
    BadgeSize.medium => 14,
  };

  TextStyle _getTextStyle(TextStyles textStyles) => switch (size) {
    BadgeSize.small => textStyles.textXs.medium,
    BadgeSize.medium => textStyles.textSm.medium,
  };

  EdgeInsets _getPadding(Spacing spacing) => EdgeInsets.symmetric(
    horizontal: icon == null ? spacing.ms : spacing.s,
    vertical: spacing.xxs,
  );

  Color _getBackgroundColor(Palette palette) => switch (type) {
    BadgeType.green => Palette.success.shade700,
    BadgeType.greenSecondary => palette.bgSuccessTertiary,
    BadgeType.warning => palette.bgWarning,
    BadgeType.error => palette.bgError,
    BadgeType.brand => palette.bgBrand,
    _ => palette.bgSecondary,
  };

  Color _getTextColor(Palette palette) => switch (type) {
    BadgeType.green => Palette.success.shade50,
    BadgeType.greenSecondary => palette.textSuccessTertiary,
    BadgeType.warning => palette.textWarningPrimary,
    BadgeType.error => palette.textErrorPrimary,
    BadgeType.brand => palette.textPrimarySelected,
    _ => palette.textPrimary,
  };

  Color _getBorderColor(Palette palette) => switch (type) {
    BadgeType.green => Palette.success.shade700,
    BadgeType.greenSecondary => palette.borderSuccessTertiary,
    BadgeType.warning => palette.borderWarning,
    BadgeType.error => palette.borderError,
    // Figma binds border-tabs here; the only token whose light/dark pair matches.
    BadgeType.brand => palette.borderTabs,
    _ => palette.borderPrimary,
  };
}

/// Colour scheme for an [AppBadge].
enum BadgeType {
  /// Neutral gray palette. Default.
  neutral,

  /// Solid green — high emphasis (e.g. "New", "Best value").
  green,

  /// Tinted green — low emphasis green.
  greenSecondary,

  /// Warning yellow/amber palette (e.g. "Expiring soon").
  warning,

  /// Error red palette (e.g. "Failed", "Action required").
  error,

  /// Brand purple — used for promotional pills such as a bonus-period badge.
  brand,
}

/// Size preset for an [AppBadge].
enum BadgeSize { small, medium }
