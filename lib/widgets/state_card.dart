import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A compact informational card with a leading icon badge, a message, and
/// an optional inline action.
///
/// Used to surface a single piece of state — for example "You are not signed
/// in" with a "Sign in" affordance. Renders a brand-tinted circular badge on
/// the left, the message text, and (when both [actionLabel] and
/// [onActionPressed] are provided) a brand-coloured action label on the
/// right.
class StateCard extends StatelessWidget {
  const StateCard({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.actionKey,
    super.key,
  }) : assert(
         (actionLabel == null) == (onActionPressed == null),
         'actionLabel and onActionPressed must be provided together.',
       );

  /// Glyph rendered inside the leading 32×32 circular badge.
  final IconData icon;

  /// Body text shown to the right of the badge.
  final String message;

  /// Label for the trailing action. When non-null, [onActionPressed] is also
  /// required and the action is rendered.
  final String? actionLabel;

  /// Callback invoked when the action label is tapped. Required whenever
  /// [actionLabel] is set.
  final VoidCallback? onActionPressed;

  /// Optional key applied to the action label widget so callers can target
  /// it from tests.
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final spacing = theme.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgModals,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: palette.borderPrimary),
        boxShadow: [
          BoxShadow(
            color: palette.shadowLg03,
            blurRadius: 2,
            spreadRadius: -1,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: palette.shadowLg02,
            blurRadius: 6,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: palette.shadowLg01,
            blurRadius: 16,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Row(
          children: [
            _IconBadge(icon: icon),
            SizedBox(width: spacing.s),
            Expanded(
              child: Text(
                message,
                style: theme.textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
              ),
            ),
            if (actionLabel case final label?) ...[
              SizedBox(width: spacing.s),
              ButtonTertiary(
                key: actionKey,
                size: ButtonSize.small,
                onPressed: onActionPressed,
                decoration: ButtonDecoration(
                  foregroundColor: palette.textBrandPrimary,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                  textStyle: theme.textStyles.textSm.semibold,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: palette.bgSecondarySelected, shape: BoxShape.circle),
      child: Center(child: Icon(icon, size: 20, color: palette.textBrandPrimary)),
    );
  }
}
