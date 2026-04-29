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
/// Uses an inverted modal surface so toasts stand out from the page — every
/// colour (background, border, text, badge) is pulled from the *opposite*
/// theme's palette ([Palette.bgModals], [Palette.borderModals], etc.). Drop
/// shadow is shadow-xs.
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
    // The snackbar's surface is inverted from the page (dark in light mode,
    // light in dark mode). Resolve every colour from the opposite theme's
    // palette so they read correctly against the inverted surface.
    final inverse = theme.brightness == Brightness.light
        ? const PaletteDark()
        : const PaletteLight();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: inverse.bgModals,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: inverse.borderModals),
        boxShadow: [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.ms),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: _badgeColor(inverse, type), shape: BoxShape.circle),
              child: Icon(_icon(type), size: 16, color: _iconColor(inverse, type)),
            ),
            SizedBox(width: theme.spacing.s),
            Expanded(
              child: Text(
                message,
                style: theme.textStyles.textSm.regular.copyWith(color: inverse.textSecondary),
              ),
            ),
            if (action != null) ...[
              SizedBox(width: theme.spacing.s),
              IconTheme(
                data: IconThemeData(color: inverse.iconSecondary, size: 16),
                child: action!,
              ),
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

  static Color _badgeColor(Palette palette, SnackbarType type) => switch (type) {
    SnackbarType.info => palette.bgInfo,
    SnackbarType.brand => palette.bgBrand,
    SnackbarType.error => palette.bgError,
    SnackbarType.warning => palette.bgWarning,
    SnackbarType.success => palette.bgSuccess,
  };

  static Color _iconColor(Palette palette, SnackbarType type) => switch (type) {
    SnackbarType.info => palette.iconInfoPrimary,
    SnackbarType.brand => palette.iconBrandPrimary,
    SnackbarType.error => palette.iconErrorPrimary,
    SnackbarType.warning => palette.iconWarningPrimary,
    SnackbarType.success => palette.iconSuccessPrimary,
  };
}
