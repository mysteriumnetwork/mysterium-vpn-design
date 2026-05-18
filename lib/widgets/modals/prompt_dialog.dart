import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A dialog that prompts the user for a permission or informs them about
/// something they can act on.
///
/// Shows an [image], [title], [subtitle], and up to two optional action
/// buttons. Layout adapts to screen size:
/// - **Mobile**: buttons stacked vertically (primary on top).
/// - **Desktop**: buttons side-by-side (secondary left, primary right).
///
/// Designed to be shown via [showModal]:
/// ```dart
/// showModal(
///   context,
///   builder: (_) => PromptDialog(
///     image: Image.asset('assets/email.png'),
///     title: 'Stay updated by email',
///     subtitle: 'Would you like to receive email updates?',
///     primaryButton: FilledButton(
///       onPressed: () {},
///       child: const Text('Allow notifications'),
///     ),
///     secondaryButton: OutlinedButton(
///       onPressed: () {},
///       child: const Text('Not now'),
///     ),
///   ),
/// );
/// ```
class PromptDialog extends StatelessWidget {
  const PromptDialog({
    required this.image,
    required this.title,
    required this.subtitle,
    this.primaryButton,
    this.secondaryButton,
    this.contentPadding,
    this.buttonsPadding,
    this.screenType,
    super.key,
  });

  /// Illustration shown above the title. Typically 100–200px tall.
  final Widget image;

  final String title;
  final String subtitle;

  /// Primary CTA. On mobile: rendered first (top). On desktop: rendered
  /// second (right). Use a [FilledButton].
  final Widget? primaryButton;

  /// Secondary CTA. On mobile: rendered second (bottom). On desktop:
  /// rendered first (left). Use an [OutlinedButton].
  final Widget? secondaryButton;

  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? buttonsPadding;

  /// Override the screen type used to pick the button layout.
  /// When null, resolved automatically via [ScreenType.of].
  final ScreenType? screenType;

  bool get hasButtons => primaryButton != null || secondaryButton != null;

  /// Canonical desktop dialog frame from the Figma spec.
  static const double _desktopWidth = 600;
  static const double _desktopHeight = 400;

  /// Inner content widths on desktop: the reading column (title + subtitle)
  /// sits inside a 311 px column, and the buttons row spans 343 px so the
  /// secondary CTA has room to expand next to the primary one.
  static const double _desktopMaxTextWidth = 311;
  static const double _desktopMaxButtonsWidth = 343;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final resolvedScreenType = screenType ?? ScreenType.of(context);
    final isDesktop = resolvedScreenType >= ScreenType.tablet;

    final contentColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        image,
        SizedBox(height: theme.spacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textStyles.textLg.bold.copyWith(color: palette.textPrimary),
        ),
        SizedBox(height: theme.spacing.md),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textStyles.textSm.medium.copyWith(color: palette.textTertiary),
        ),
      ],
    );

    Widget constrain(Widget child, double maxWidth) => isDesktop
        ? Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          )
        : child;

    final body = Material(
      child: ColoredBox(
        color: palette.bgPrimary,
        child: SafeArea(
          child: Column(
            children: [
              // ── Content fills the available vertical space, centred ────────
              Expanded(
                child: Padding(
                  padding: contentPadding ?? EdgeInsets.symmetric(horizontal: theme.spacing.xl2),
                  child: Center(child: constrain(contentColumn, _desktopMaxTextWidth)),
                ),
              ),

              // ── Action buttons pinned to the bottom ────────────────────────
              if (hasButtons)
                Padding(
                  padding:
                      buttonsPadding ??
                      EdgeInsets.fromLTRB(theme.spacing.md, 0, theme.spacing.md, theme.spacing.xl5),
                  child: constrain(
                    isDesktop
                        ? _DesktopButtons(
                            primaryButton: primaryButton,
                            secondaryButton: secondaryButton,
                            spacing: theme.spacing.s,
                          )
                        : _MobileButtons(
                            primaryButton: primaryButton,
                            secondaryButton: secondaryButton,
                            spacing: theme.spacing.s,
                          ),
                    _desktopMaxButtonsWidth,
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    // Lock the desktop frame to the Figma canvas (600×400) so callers don't
    // have to pass desktopConstraints to showModal.
    return isDesktop ? SizedBox(width: _desktopWidth, height: _desktopHeight, child: body) : body;
  }
}

// ─── Mobile: stacked column (primary first) ───────────────────────────────────

class _MobileButtons extends StatelessWidget {
  const _MobileButtons({required this.spacing, this.primaryButton, this.secondaryButton});

  final Widget? primaryButton;
  final Widget? secondaryButton;
  final double spacing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: spacing,
    children: [?primaryButton, ?secondaryButton],
  );
}

// ─── Desktop: side-by-side row (secondary left, primary right) ────────────────
//
// Per Figma: secondary stretches to fill the row, primary stays intrinsic.
// With the row capped at 343 px and a typical primary label (~200 px), the
// secondary lands around 135 px — narrow enough to read as the lower-emphasis
// option, wide enough not to look squeezed.

class _DesktopButtons extends StatelessWidget {
  const _DesktopButtons({required this.spacing, this.primaryButton, this.secondaryButton});

  final Widget? primaryButton;
  final Widget? secondaryButton;
  final double spacing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: spacing,
    children: [
      if (secondaryButton case final btn?) Expanded(child: btn),
      ?primaryButton,
    ],
  );
}
