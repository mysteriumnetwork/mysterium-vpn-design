import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A compact progress card with optional icon badge, progress row, text, and action.
///
/// The card is commonly used for onboarding or feature hints where users see
/// completion status (e.g. "3 / 6"), a short title/description, and a trailing
/// tertiary action.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.actionlabel,
    required this.onActionPressed,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.progressValue,
    this.progressLabel,
    this.title,
    this.description,
    super.key,
  });

  /// Optional glyph rendered in a 32x32 circular badge.
  final IconData? icon;

  /// Completion fraction (`0`-`1`) used by the linear [ProgressBar].
  ///
  /// When null, no progress bar is rendered.
  final double? progressValue;

  /// Optional trailing progress text (for example: `3 / 6`).
  final String? progressLabel;

  /// Optional override for the icon foreground color.
  final Color? iconColor;

  /// Optional title shown under the progress row.
  final String? title;

  /// Optional supporting description shown under [title].
  final String? description;

  /// Label of the trailing tertiary action.
  final String actionlabel;

  /// Callback invoked when the trailing action is tapped.
  final VoidCallback onActionPressed;

  /// Optional background override for both light and dark themes.
  ///
  /// When null, [Palette.bgInfoCard] from the active theme is used.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;

    final bgColor = _getBackgroundColor(theme);

    final progressHeader = Row(
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: spacing.md),
            child: _IconBadge(
              icon: icon!,
              iconColor: _getIconColor(theme),
              backgroundColor: _getIconBadgeColor(theme),
            ),
          ),
        if (progressValue != null) Expanded(child: ProgressBar.linear(value: progressValue!)),
        if (progressLabel != null)
          Padding(
            padding: EdgeInsets.only(left: spacing.md),
            child: SizedBox(
              width: spacing.xl3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  progressLabel!,
                  style: TextStyles(color: _getProgressLabelColor(theme)).textXs.regular,
                ),
              ),
            ),
          ),
      ],
    );

    return Container(
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.kM), color: bgColor),
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          progressHeader,
          if (progressHeader.children.isNotEmpty) SizedBox(height: spacing.ms),
          if (title != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.ms),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textStyles.textMd.semibold.copyWith(
                        color: _getTitleColor(theme),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (description != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.s),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      description!,
                      style: theme.textStyles.textXs.regular.copyWith(
                        color: _getDescriptionColor(theme),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: spacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonTertiary(
                  onPressed: onActionPressed,
                  decoration: ButtonDecoration(
                    foregroundColor: _getActionColor(theme),
                    textStyle: theme.textStyles.textSm.semibold,
                    padding: EdgeInsets.symmetric(horizontal: spacing.none),
                  ),
                  child: Text(actionlabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) =>
      backgroundColor ??
      (theme.brightness == Brightness.dark
          ? Palette.grayLight.shade800
          : Palette.grayLight.shade25);

  Color _getIconBadgeColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.brand.shade900 : Palette.brand.shade100;

  Color _getIconColor(ThemeData theme) =>
      iconColor ?? (theme.brightness == Brightness.dark ? Palette.brand.shade400 : Palette.brand);

  Color _getTitleColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.white : Palette.grayLight.shade800;

  Color _getDescriptionColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.white.withAlpha(143) : Palette.grayLight;

  Color _getActionColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.brand.shade300 : Palette.brand.shade600;

  Color _getProgressLabelColor(ThemeData theme) => theme.brightness == Brightness.dark
      ? Palette.grayPurple.shade300
      : Palette.grayLight.shade400;
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.iconColor, required this.backgroundColor});

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 16,
    backgroundColor: backgroundColor,
    child: Icon(icon, color: iconColor, size: 20),
  );
}
