import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ─── Sandbox use case (toggle each slot) ─────────────────────────────────────

@UseCase(name: 'Sandbox', type: OnboardingItem)
Widget buildOnboardingItemSandbox(BuildContext context) {
  final showLeading = context.knobs.boolean(label: 'Show leading icon', initialValue: true);
  final label = context.knobs.string(label: 'Label', initialValue: 'IP address');
  final value = context.knobs.string(label: 'Value', initialValue: '84.122.47.219');
  final trailing = context.knobs.object.dropdown<_TrailingKind>(
    label: 'Trailing',
    initialOption: _TrailingKind.exposedDot,
    options: _TrailingKind.values,
    labelBuilder: (k) => k.name,
  );
  final accent = context.knobs.object.dropdown<_Accent>(
    label: 'Border accent',
    initialOption: _Accent.none,
    options: _Accent.values,
    labelBuilder: (a) => a.name,
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 343),
        child: OnboardingItem(
          leading: showLeading ? const _LeadingIcon(icon: UntitledUI.globe_02) : null,
          label: label.isEmpty ? null : label,
          value: value.isEmpty ? null : value,
          trailing: switch (trailing) {
            _TrailingKind.none => null,
            _TrailingKind.exposedDot => const _IndicatorDot(exposed: true),
            _TrailingKind.protectedDot => const _IndicatorDot(exposed: false),
            _TrailingKind.unprotectedPill => const _StatusPill(exposed: true, label: 'UNPROTECTED'),
            _TrailingKind.protectedPill => const _StatusPill(exposed: false, label: 'PROTECTED'),
          },
          borderColor: _accentColor(context, accent),
        ),
      ),
    ),
  );
}

// ─── Composed-cards use case (matches the Figma onboarding stacks) ────────────

@UseCase(name: 'Onboarding stack', type: OnboardingItem)
Widget buildOnboardingItemStack(BuildContext context) {
  final isProtected = context.knobs.boolean(label: 'Protected state');
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final accent = isProtected
      ? (isDark ? Palette.success.shade900 : Palette.success.shade200)
      : (isDark ? Palette.error.shade400.withValues(alpha: 0.25) : Palette.error.shade200);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 343),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: theme.spacing.ms,
          children: [
            OnboardingItem(
              label: 'Connection',
              trailing: _StatusPill(
                exposed: !isProtected,
                label: isProtected ? 'PROTECTED' : 'UNPROTECTED',
              ),
              borderColor: accent,
            ),
            OnboardingItem(
              leading: const _LeadingIcon(icon: UntitledUI.globe_02),
              label: 'IP address',
              value: isProtected ? '••.•••.••.•••' : '84.122.47.219',
              trailing: _IndicatorDot(exposed: !isProtected),
            ),
            OnboardingItem(
              leading: const _LeadingIcon(icon: UntitledUI.marker_pin_01),
              label: 'Location',
              value: isProtected ? 'Berlin, Germany 🇩🇪' : 'Madrid, Spain 🇪🇸',
              trailing: _IndicatorDot(exposed: !isProtected),
            ),
            OnboardingItem(
              leading: const _LeadingIcon(icon: UntitledUI.wifi),
              label: 'ISP',
              value: isProtected ? 'Hidden' : 'Vodafone Iberia',
              trailing: _IndicatorDot(exposed: !isProtected),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Sandbox knob enums ───────────────────────────────────────────────────────

enum _TrailingKind { none, exposedDot, protectedDot, unprotectedPill, protectedPill }

enum _Accent { none, exposed, protected }

Color? _accentColor(BuildContext context, _Accent accent) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return switch (accent) {
    _Accent.none => null,
    _Accent.exposed =>
      isDark ? Palette.error.shade400.withValues(alpha: 0.25) : Palette.error.shade200,
    _Accent.protected => isDark ? Palette.success.shade900 : Palette.success.shade200,
  };
}

// ─── Local helpers used to compose the demo cards ────────────────────────────

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Palette.grayLight.shade950 : Palette.grayLight.shade100;
    final border = isDark
        ? Palette.grayDarkAlpha.shade700
        : Palette.grayLight.shade200.withValues(alpha: 0.6);
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: border),
      ),
      child: Center(child: Icon(icon, size: 14, color: palette.textTertiary)),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  const _IndicatorDot({required this.exposed});

  final bool exposed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = exposed
        ? (isDark ? Palette.error.shade700 : Palette.error.shade600)
        : (isDark ? Palette.success.shade700 : Palette.success.shade600);
    final glow = (exposed ? Palette.error : Palette.success).withValues(alpha: 0.55);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: glow, blurRadius: 6, spreadRadius: -1, offset: const Offset(0, 2)),
        ],
      ),
      child: Center(
        child: Icon(exposed ? UntitledUI.eye : UntitledUI.check, size: 12, color: Palette.white),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.exposed, required this.label});

  final bool exposed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (bg, border, text, icon) = exposed
        ? (
            isDark ? Palette.error.shade700 : Palette.error.shade600,
            isDark ? Palette.error.shade500 : Palette.error.shade200,
            isDark ? Palette.error.shade100 : Palette.white,
            UntitledUI.alert_circle,
          )
        : (
            isDark ? Palette.success.shade700 : Palette.success.shade600,
            isDark ? Palette.success.shade500 : Palette.success.shade200,
            isDark ? Palette.success.shade100 : Palette.white,
            UntitledUI.shield_tick,
          );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.all(theme.radius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          SizedBox(width: theme.spacing.sm),
          Text(
            label,
            style: theme.textStyles.textXs.bold.copyWith(
              color: text,
              fontSize: 11,
              height: 15.75 / 11,
              letterSpacing: 0.525,
            ),
          ),
        ],
      ),
    );
  }
}
