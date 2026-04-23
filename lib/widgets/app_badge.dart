import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A small pill-shaped label used to tag or annotate content.
///
/// Use [type] to pick a colour scheme (neutral / green / green secondary)
/// and [size] for density.
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.text,
    this.type = BadgeType.neutral,
    this.size = BadgeSize.medium,
    super.key,
  });

  /// Label shown inside the badge. Rendered on a single line.
  final String text;

  /// Colour scheme. Defaults to [BadgeType.neutral].
  final BadgeType type;

  /// Badge density preset. Defaults to [BadgeSize.medium].
  final BadgeSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    return Container(
      padding: _getPadding(theme.spacing),
      decoration: BoxDecoration(
        color: _getBackgroundColor(palette),
        borderRadius: BorderRadius.all(theme.radius.full),
        border: Border.all(color: _getBorderColor(palette)),
      ),
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
        style: _getTextStyle(theme.textStyles).copyWith(color: _getTextColor(palette)),
      ),
    );
  }

  TextStyle _getTextStyle(TextStyles textStyles) => switch (size) {
    BadgeSize.small => textStyles.textXs.medium,
    BadgeSize.medium => textStyles.textSm.medium,
  };

  EdgeInsets _getPadding(Spacing spacing) => switch (size) {
    BadgeSize.small => EdgeInsets.symmetric(horizontal: spacing.ms, vertical: spacing.xxs),
    BadgeSize.medium => EdgeInsets.symmetric(horizontal: spacing.ms, vertical: spacing.xxs),
  };

  Color _getBackgroundColor(Palette palette) => switch (type) {
    BadgeType.green => Palette.success.shade700,
    BadgeType.greenSecondary => palette.bgSuccessTertiary,
    _ => palette.bgSecondary,
  };

  Color _getTextColor(Palette palette) => switch (type) {
    BadgeType.green => Palette.success.shade50,
    BadgeType.greenSecondary => palette.textSuccessTertiary,
    _ => palette.textPrimary,
  };

  Color _getBorderColor(Palette palette) => switch (type) {
    BadgeType.green => Palette.success.shade700,
    BadgeType.greenSecondary => palette.borderSuccessTertiary,
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
}

/// Size preset for an [AppBadge].
enum BadgeSize { small, medium }
