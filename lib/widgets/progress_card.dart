import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A compact progress card with optional icon badge, progress row, text, and action.
///
/// The card is commonly used for onboarding or feature hints where users see
/// completion status (e.g. "3 / 6"), a short title/description, and a trailing
/// tertiary action.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.actionLabel,
    required this.onActionPressed,
    this.icon,
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

  /// Optional title shown under the progress row.
  final String? title;

  /// Optional supporting description shown under [title].
  final String? description;

  /// Label of the trailing tertiary action.
  final String actionLabel;

  /// Callback invoked when the trailing action is tapped.
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;

    final bgColor = _getBackgroundColor(theme);

    return Container(
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.kM), color: bgColor),
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(icon: icon, progressValue: progressValue, progressLabel: progressLabel),
          _Content(
            title: title,
            description: description,
            actionLabel: actionLabel,
            onActionPressed: onActionPressed,
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.grayLight.shade800 : Palette.grayLight.shade25;
}

class _Header extends StatelessWidget {
  const _Header({required this.icon, required this.progressValue, required this.progressLabel});

  final IconData? icon;
  final double? progressValue;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = Theme.of(context).spacing;
    final iconColor = _getIconColor(theme);
    final iconBadgeColor = _getIconBadgeColor(theme);
    final progressLabelColor = _getProgressLabelColor(theme);
    return Row(
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: spacing.md),
            child: _IconBadge(icon: icon!, iconColor: iconColor, backgroundColor: iconBadgeColor),
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
                  style: TextStyles(color: progressLabelColor).textXs.regular,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getIconBadgeColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.brand.shade900 : Palette.brand.shade100;

  Color _getIconColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.brand.shade400 : Palette.brand;

  Color _getProgressLabelColor(ThemeData theme) => theme.brightness == Brightness.dark
      ? Palette.grayPurple.shade300
      : Palette.grayLight.shade400;
}

class _Content extends StatelessWidget {
  const _Content({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onActionPressed,
  });

  final String? title;
  final String? description;
  final String actionLabel;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;
    final titleColor = _getTitleColor(theme);
    final descriptionColor = _getDescriptionColor(theme);
    final actionColor = _getActionColor(theme);

    return Padding(
      padding: EdgeInsets.only(top: spacing.ms),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.ms),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textStyles.textMd.semibold.copyWith(color: titleColor),
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
                      style: theme.textStyles.textXs.regular.copyWith(color: descriptionColor),
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
                    foregroundColor: actionColor,
                    textStyle: theme.textStyles.textSm.semibold,
                    padding: EdgeInsets.symmetric(horizontal: spacing.none),
                  ),
                  child: Text(actionLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTitleColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.white : Palette.grayLight.shade800;

  Color _getDescriptionColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.white.withAlpha(143) : Palette.grayLight;

  Color _getActionColor(ThemeData theme) =>
      theme.brightness == Brightness.dark ? Palette.brand.shade300 : Palette.brand.shade600;
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
