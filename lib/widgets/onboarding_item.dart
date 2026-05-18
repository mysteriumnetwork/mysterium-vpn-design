import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

// Cap on the label's natural width — labels like "Location", "IP address",
// "Connection" stay well below this in practice; the cap only kicks in for
// pathologically long translations so they ellipsize instead of pushing the
// value text off-screen.
const _kLabelMaxWidth = 130.0;

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
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: spacing.ms)],
            if (label case final l?)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kLabelMaxWidth),
                child: Text(
                  l,
                  style: theme.textStyles.textXs.medium.copyWith(color: palette.textTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (value != null || trailing != null) ...[
              if (value case final v?)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: spacing.s),
                    child: Text(
                      v,
                      textAlign: TextAlign.right,
                      style: theme.textStyles.textSm.medium.copyWith(color: palette.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              else
                const Spacer(),
              if (trailing case final t?) ...[if (value != null) SizedBox(width: spacing.s), t],
            ],
          ],
        ),
      ),
    );
  }
}
