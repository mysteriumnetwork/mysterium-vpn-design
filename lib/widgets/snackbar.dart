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

// State-layer alphas for the action button's overlay, matching the icon
// overlays used elsewhere in the system.
const _actionHoveredAlpha = 0.16;
const _actionPressedAlpha = 0.24;

/// A toast-style status banner with a leading icon badge and a body of
/// supporting text. Long messages wrap to multiple lines.
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
    final isLightPage = theme.brightness == Brightness.light;
    final inverse = isLightPage ? const PaletteDark() : const PaletteLight();

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
              // Hand the action the inverted theme as well, so a button dropped
              // in here resolves its brand colour and hover against the
              // snackbar's surface instead of the page's.
              Theme(
                data: _actionTheme(isLightPage ? DesignSystem.darkTheme : DesignSystem.lightTheme),
                child: IconTheme(
                  data: IconThemeData(color: inverse.iconSecondary, size: 16),
                  child: action!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// [inverse] with its text buttons re-tuned for this surface: the brand
  /// colour held steady across every state, with hover/press shown as a tint
  /// of it. The stock theme instead darkens the label to brand-700 over a
  /// page-coloured overlay, which on the inverted surface reads as the label
  /// vanishing into a smear.
  ///
  /// Merges into the inverted theme's own button style rather than replacing
  /// it, so text style, shape and disabled colours survive.
  static ThemeData _actionTheme(ThemeData inverse) {
    final brand = inverse.palette.textBrandPrimary;
    final base = inverse.textButtonTheme.style;

    // Steady on brand while the button is usable, but disabled still defers to
    // the theme — an unusable action that keeps the brand colour reads enabled.
    WidgetStateProperty<Color?> steadyBrand(WidgetStateProperty<Color?>? fallback) =>
        WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? fallback?.resolve(states) : brand,
        );

    return inverse.copyWith(
      textButtonTheme: TextButtonThemeData(
        style: base?.copyWith(
          foregroundColor: steadyBrand(base.foregroundColor),
          iconColor: steadyBrand(base.iconColor),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.pressed)) {
              return brand.withValues(alpha: _actionPressedAlpha);
            }
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
              return brand.withValues(alpha: _actionHoveredAlpha);
            }
            return null;
          }),
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
