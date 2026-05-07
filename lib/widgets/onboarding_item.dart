import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A flexible card row used in onboarding screens.
///
/// Holds up to four optional slots: [leading] and [label] on the left,
/// [value] and [trailing] on the right. Right-side slots always hug the
/// right edge regardless of left-side content. Pass [borderColor] for an
/// accent border (e.g. red for "exposed", green for "protected").
class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    this.leading,
    this.label,
    this.value,
    this.trailing,
    this.borderColor,
    super.key,
  });

  /// Far-left slot — typically a small decorated icon container.
  final Widget? leading;

  /// Left-aligned label text shown after [leading].
  final String? label;

  /// Right-aligned value text shown before [trailing].
  final String? value;

  /// Far-right slot — typically a status pill or indicator dot.
  final Widget? trailing;

  /// Override for the card border colour. Falls back to [Palette.borderInfoCard].
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final spacing = theme.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgInfoCard,
        borderRadius: const BorderRadius.all(Radius.kXl),
        border: Border.all(color: borderColor ?? palette.borderInfoCard),
        boxShadow: [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        // Left cluster (Expanded) absorbs remaining width so the right cluster
        // is pinned to the right edge by spaceBetween. Wrapping the label in
        // Flexible inside the left cluster lets it ellipsize before pushing
        // the right cluster off-screen.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[leading!, SizedBox(width: spacing.ms)],
                  if (label case final l?)
                    Flexible(
                      child: Text(
                        l,
                        style: theme.textStyles.textXs.medium.copyWith(
                          color: palette.textTertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            if (value != null || trailing != null)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (value case final v?)
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: spacing.s),
                          child: Text(
                            v,
                            textAlign: TextAlign.right,
                            style: theme.textStyles.textSm.medium.copyWith(
                              color: palette.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    if (trailing case final t?) ...[
                      if (value != null) SizedBox(width: spacing.s),
                      t,
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
