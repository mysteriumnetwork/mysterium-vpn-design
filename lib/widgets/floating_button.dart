import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A compact floating action with a text label and trailing icon.
///
/// Used for low-emphasis overlay actions such as skipping onboarding or
/// dismissing a flow. Colors adapt to light and dark theme via fixed
/// palette tokens (not the primary/secondary [Button] variants).
///
/// Pass `null` to [onPressed] to render the control in a disabled state with
/// muted background and foreground colors.
///
/// ```dart
/// FloatingButton(
///   label: 'Skip',
///   icon: UntitledUI.x_close,
///   onPressed: onSkip,
/// )
/// ```
class FloatingButton extends StatelessWidget {
  const FloatingButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  /// Caption shown to the left of [icon]. Rendered with `textSm.regular`.
  final String label;

  /// Trailing glyph, typically a close or dismiss icon at 16 px.
  final IconData icon;

  /// Tap handler. When `null`, the button is non-interactive.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;
    final isDisabled = onPressed == null;
    final foregroundColor = isDisabled
        ? _disabledForegroundColor(theme)
        : _foregroundColor(theme);

    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(theme.radius.full)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return _disabledBackgroundColor(theme);
          }
          return _backgroundColor(theme);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return _disabledForegroundColor(theme);
          }
          return _foregroundColor(theme);
        }),
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return _disabledForegroundColor(theme);
          }
          return _foregroundColor(theme);
        }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.s),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textStyles.textSm.regular.copyWith(color: foregroundColor),
          ),
          SizedBox(width: spacing.xs),
          Icon(icon, color: foregroundColor, size: 16),
        ],
      ),
    );
  }

  Color _backgroundColor(ThemeData theme) => switch (theme.brightness) {
    Brightness.dark => Palette.grayDark.shade800,
    Brightness.light => Palette.grayLight.shade25,
  };

  Color _disabledBackgroundColor(ThemeData theme) => switch (theme.brightness) {
    Brightness.dark => Palette.grayDarkAlpha.shade800,
    Brightness.light => Palette.grayLight.shade100,
  };

  Color _foregroundColor(ThemeData theme) => switch (theme.brightness) {
    Brightness.dark => Palette.white,
    Brightness.light => Palette.grayDark.shade800,
  };

  Color _disabledForegroundColor(ThemeData theme) => switch (theme.brightness) {
    Brightness.dark => Palette.grayDarkAlpha.shade600,
    Brightness.light => Palette.grayLight.shade400,
  };
}
