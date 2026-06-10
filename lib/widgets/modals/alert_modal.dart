import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// Right-side breathing room reserved for the floating close button so title
// and supporting text don't render underneath it. Derived from the close
// button geometry (36 px wide + 7 px right inset = 43) minus the modal's
// outer 16 px padding (= 27), rounded up to 32 for a small visual buffer.
const double _closeButtonClearance = 32;

/// Status conveyed by an [AlertModal] — selects the leading icon and the
/// colour of its circular badge.
enum AlertModalType {
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

/// A floating alert dialog with a leading status icon, title, optional
/// supporting text, optional input field, and up to two optional action
/// buttons.
///
/// Surface uses [Palette.bgModals] with [Palette.borderModals] and the
/// shadow-lg drop shadow. The leading badge pulls its background and icon
/// colours from the theme (`bg{Type}` and `icon{Type}Primary`); pass [icon] to
/// override just the badge glyph (colours still follow [type]). Surface padding
/// defaults to [Spacing.md] on every side and can be overridden via [padding].
///
/// Layout adapts to screen size:
/// - **Desktop** (`screenType >= tablet`): horizontal — icon left, content
///   on the right (title, supporting text, input, actions row). Close
///   button floats top-right. Actions render side-by-side, secondary
///   left, primary right.
/// - **Mobile** (`screenType <= mobile`): vertical — badge icon at top,
///   followed by title, supporting text, input, and actions stacked
///   (primary on top, secondary below). Close button floats top-right.
class AlertModal extends StatelessWidget {
  const AlertModal({
    required this.title,
    this.supportingText,
    this.type = AlertModalType.brand,
    this.icon,
    this.showIcon = true,
    this.primaryButton,
    this.secondaryButton,
    this.onClose,
    this.input,
    this.screenType,
    this.padding,
    super.key,
  });

  final String title;

  /// Secondary line under the title. Hidden when null.
  final String? supportingText;

  /// Status the alert conveys. Drives the badge's background and icon colours.
  final AlertModalType type;

  /// Overrides the badge glyph. When null the icon is derived from [type].
  /// The badge background/foreground colours still come from [type].
  final IconData? icon;

  /// Whether to render the leading icon badge.
  final bool showIcon;

  /// Primary CTA. Desktop: rendered on the right of the actions row.
  /// Mobile: rendered on top of the actions column. Use [ButtonPrimary].
  final Widget? primaryButton;

  /// Secondary CTA. Desktop: rendered on the left of the actions row.
  /// Mobile: rendered below the primary. Use [ButtonSecondary].
  final Widget? secondaryButton;

  /// Tap handler for the × button. When null no close button is shown.
  final VoidCallback? onClose;

  /// Optional widget rendered between the text block and the actions —
  /// typically a text input.
  final Widget? input;

  /// Override the screen type used to pick the layout. When null,
  /// resolved automatically via [ScreenType.of].
  final ScreenType? screenType;

  /// Surface padding. Defaults to [Spacing.md] on every side.
  final EdgeInsets? padding;

  bool get _hasButtons => primaryButton != null || secondaryButton != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final resolved = screenType ?? ScreenType.of(context);
    final isDesktop = resolved >= ScreenType.tablet;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgModals,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: palette.borderModals),
        boxShadow: [
          BoxShadow(
            color: palette.shadowLg03,
            offset: const Offset(0, 2),
            blurRadius: 2,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: palette.shadowLg02,
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: palette.shadowLg01,
            offset: const Offset(0, 12),
            blurRadius: 16,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: padding ?? EdgeInsets.all(theme.spacing.md),
            child: isDesktop ? _buildDesktop(context) : _buildMobile(context),
          ),
          if (onClose != null)
            Positioned(
              top: 7,
              right: 7,
              child: _CloseButton(onPressed: onClose!, color: palette.iconTertiary),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showIcon) ...[_Badge(type: type, icon: icon), SizedBox(width: theme.spacing.s)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: theme.spacing.ms,
            children: [
              _TextBlock(
                title: title,
                supportingText: supportingText,
                rightClearance: onClose != null ? _closeButtonClearance : 0,
              ),
              ?input,
              if (_hasButtons)
                _DesktopActions(
                  primaryButton: primaryButton,
                  secondaryButton: secondaryButton,
                  spacing: theme.spacing.s,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.ms,
      children: [
        if (showIcon)
          Align(
            alignment: Alignment.centerLeft,
            child: _Badge(type: type, icon: icon),
          ),
        _TextBlock(
          title: title,
          supportingText: supportingText,
          // Reserve room for the close button only when the icon isn't
          // already pushing the title down.
          rightClearance: !showIcon && onClose != null ? _closeButtonClearance : 0,
        ),
        ?input,
        if (_hasButtons)
          _MobileActions(
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
            spacing: theme.spacing.s,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.type, this.icon});

  final AlertModalType type;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: _bg(palette, type), shape: BoxShape.circle),
      child: Icon(icon ?? _icon(type), size: 20, color: _fg(palette, type)),
    );
  }

  static IconData _icon(AlertModalType type) => switch (type) {
    AlertModalType.info => UntitledUI.info_circle,
    AlertModalType.brand => UntitledUI.check_circle,
    AlertModalType.error => UntitledUI.alert_circle,
    AlertModalType.warning => UntitledUI.alert_triangle,
    AlertModalType.success => UntitledUI.check_circle,
  };

  static Color _bg(Palette palette, AlertModalType type) => switch (type) {
    AlertModalType.info => palette.bgInfo,
    AlertModalType.brand => palette.bgBrand,
    AlertModalType.error => palette.bgError,
    AlertModalType.warning => palette.bgWarning,
    AlertModalType.success => palette.bgSuccess,
  };

  static Color _fg(Palette palette, AlertModalType type) => switch (type) {
    AlertModalType.info => palette.iconInfoPrimary,
    AlertModalType.brand => palette.iconBrandPrimary,
    AlertModalType.error => palette.iconErrorPrimary,
    AlertModalType.warning => palette.iconWarningPrimary,
    AlertModalType.success => palette.iconSuccessPrimary,
  };
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.title, required this.rightClearance, this.supportingText});

  final String title;
  final String? supportingText;

  /// Right-side padding applied to both [title] and [supportingText] so they
  /// don't render underneath the floating close button.
  final double rightClearance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Padding(
      padding: EdgeInsets.only(right: rightClearance),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing.xs,
        children: [
          Text(
            title,
            style: theme.textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
          ),
          if (supportingText case final s?)
            Text(s, style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary)),
        ],
      ),
    );
  }
}

class _DesktopActions extends StatelessWidget {
  const _DesktopActions({required this.spacing, this.primaryButton, this.secondaryButton});

  final Widget? primaryButton;
  final Widget? secondaryButton;
  final double spacing;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (secondaryButton != null) Flexible(child: secondaryButton!),
      if (secondaryButton != null && primaryButton != null) SizedBox(width: spacing),
      if (primaryButton != null) Flexible(child: primaryButton!),
    ],
  );
}

class _MobileActions extends StatelessWidget {
  const _MobileActions({required this.spacing, this.primaryButton, this.secondaryButton});

  final Widget? primaryButton;
  final Widget? secondaryButton;
  final double spacing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    spacing: spacing,
    children: [?primaryButton, ?secondaryButton],
  );
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed, required this.color});

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
    padding: EdgeInsets.zero,
    icon: Icon(UntitledUI.x_close, size: 20, color: color),
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.kXs)),
      ),
      minimumSize: WidgetStateProperty.all(const Size(36, 36)),
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );
}
