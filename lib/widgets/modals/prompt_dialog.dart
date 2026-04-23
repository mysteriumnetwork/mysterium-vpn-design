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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final resolvedScreenType = screenType ?? ScreenType.of(context);
    final isDesktop = resolvedScreenType >= ScreenType.tablet;

    return Material(
      child: ColoredBox(
        color: palette.bgPrimary,
        child: SafeArea(
          child: Column(
            children: [
              // ── Centred content ──────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: contentPadding ?? EdgeInsets.symmetric(horizontal: theme.spacing.xl2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image,
                      SizedBox(height: theme.spacing.xl4),
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
                  ),
                ),
              ),

              // ── Action buttons ───────────────────────────────────────────────
              if (hasButtons)
                Padding(
                  padding:
                      buttonsPadding ??
                      EdgeInsets.fromLTRB(theme.spacing.md, 0, theme.spacing.md, theme.spacing.xl5),
                  child: isDesktop
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
                ),
            ],
          ),
        ),
      ),
    );
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
