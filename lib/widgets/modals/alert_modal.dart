import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
    this.showIcon = true,
    this.primaryButton,
    this.secondaryButton,
    this.onClose,
    this.input,
    this.screenType,
    super.key,
  });

  final String title;

  /// Secondary line under the title. Hidden when null.
  final String? supportingText;

  /// Status the alert conveys.
  final AlertModalType type;

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

  bool get _hasButtons => primaryButton != null || secondaryButton != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final resolved = screenType ?? ScreenType.of(context);
    final isDesktop = resolved >= ScreenType.tablet;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.borderPrimary),
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
            padding: EdgeInsets.all(theme.spacing.md),
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
        if (showIcon) ...[_Badge(type: type), SizedBox(width: theme.spacing.s)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: theme.spacing.ms,
            children: [
              _TextBlock(
                title: title,
                supportingText: supportingText,
                titleRightPadding: onClose != null ? theme.spacing.xl3 : 0,
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
            child: _Badge(type: type),
          ),
        _TextBlock(
          title: title,
          supportingText: supportingText,
          // Reserve room for the close button only when the icon isn't
          // already pushing the title down.
          titleRightPadding: !showIcon && onClose != null ? theme.spacing.xl3 : 0,
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
  const _Badge({required this.type});

  final AlertModalType type;

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(color: _bg(type), shape: BoxShape.circle),
    child: Icon(_icon(type), size: 20, color: _fg(type)),
  );

  static IconData _icon(AlertModalType type) => switch (type) {
    AlertModalType.info => UntitledUI.info_circle,
    AlertModalType.brand => UntitledUI.check_circle,
    AlertModalType.error => UntitledUI.alert_circle,
    AlertModalType.warning => UntitledUI.alert_triangle,
    AlertModalType.success => UntitledUI.check_circle,
  };

  static Color _bg(AlertModalType type) => switch (type) {
    AlertModalType.info => Palette.grayLight.shade100,
    AlertModalType.brand => Palette.brand.shade100,
    AlertModalType.error => Palette.error.shade200,
    AlertModalType.warning => Palette.warning.shade100,
    AlertModalType.success => Palette.success.shade100,
  };

  static Color _fg(AlertModalType type) => switch (type) {
    AlertModalType.info => Palette.grayLight.shade600,
    AlertModalType.brand => Palette.brand.shade600,
    AlertModalType.error => Palette.error.shade600,
    AlertModalType.warning => Palette.warning.shade600,
    AlertModalType.success => Palette.success.shade600,
  };
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.title, required this.titleRightPadding, this.supportingText});

  final String title;
  final String? supportingText;
  final double titleRightPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: theme.spacing.xs,
      children: [
        Padding(
          padding: EdgeInsets.only(right: titleRightPadding),
          child: Text(
            title,
            style: theme.textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
          ),
        ),
        if (supportingText case final s?)
          Text(s, style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary)),
      ],
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
      ?secondaryButton,
      if (secondaryButton != null && primaryButton != null) SizedBox(width: spacing),
      ?primaryButton,
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
    padding: EdgeInsets.zero,
    icon: Icon(UntitledUI.x_close, size: 20, color: color),
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.kS)),
      ),
      minimumSize: WidgetStateProperty.all(const Size(36, 36)),
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );
}
