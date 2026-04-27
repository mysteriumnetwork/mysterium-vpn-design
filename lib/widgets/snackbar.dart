import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Status conveyed by a [Snackbar]. Selects the leading icon and the colour
/// of its circular badge.
enum SnackbarType {
  /// Neutral information. Renders an info-circle on a light gray badge.
  info,

  /// Default brand-styled confirmation. Renders a check-circle on a brand badge.
  brand,

  /// Destructive / error feedback. Renders an alert-circle on a red badge.
  error,

  /// Cautionary / warning feedback. Renders an alert-triangle on a yellow badge.
  warning,

  /// Positive confirmation. Renders a check-circle on a green badge.
  success,
}

/// A toast-style status banner with a leading icon badge and a single line of
/// supporting text.
///
/// Uses the project's standard surface treatment (primary background, primary
/// border, shadow-xs drop shadow). The leading icon and its circular badge
/// change with [type].
class Snackbar extends StatelessWidget {
  const Snackbar({required this.message, this.type = SnackbarType.brand, this.action, super.key});

  /// Body copy rendered to the right of the icon. Wraps to multiple lines
  /// if the parent's width forces it.
  final String message;

  /// Status the snackbar conveys.
  final SnackbarType type;

  /// Optional trailing widget (e.g. an [IconButton]) rendered after the message.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: palette.borderPrimary),
        boxShadow: [
          BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.ms),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: _badgeColor(type), shape: BoxShape.circle),
              child: Icon(_icon(type), size: 16, color: _iconColor(type)),
            ),
            SizedBox(width: theme.spacing.s),
            Expanded(
              child: Text(
                message,
                style: theme.textStyles.textSm.regular.copyWith(color: palette.textSecondary),
              ),
            ),
            if (action != null) ...[
              SizedBox(width: theme.spacing.s),
              action!,
            ],
          ],
        ),
      ),
    );
  }

  static IconData _icon(SnackbarType type) => switch (type) {
    SnackbarType.info => UntitledUI.info_circle,
    SnackbarType.brand => UntitledUI.check_circle,
    SnackbarType.error => UntitledUI.alert_circle,
    SnackbarType.warning => UntitledUI.alert_triangle,
    SnackbarType.success => UntitledUI.check_circle,
  };

  static Color _badgeColor(SnackbarType type) => switch (type) {
    SnackbarType.info => Palette.grayLight.shade100,
    SnackbarType.brand => Palette.brand.shade100,
    SnackbarType.error => Palette.error.shade200,
    SnackbarType.warning => Palette.warning.shade100,
    SnackbarType.success => Palette.success.shade100,
  };

  static Color _iconColor(SnackbarType type) => switch (type) {
    SnackbarType.info => Palette.grayLight.shade600,
    SnackbarType.brand => Palette.brand.shade600,
    SnackbarType.error => Palette.error.shade600,
    SnackbarType.warning => Palette.warning.shade600,
    SnackbarType.success => Palette.success.shade600,
  };
}
