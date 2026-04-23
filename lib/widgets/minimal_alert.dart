import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A dismissible informational banner with optional tooltip.
///
/// Shows [message] in a styled card. When a tooltip is provided an
/// [info-circle] [TooltipIcon] is rendered inline after the text.
/// When [onDismiss] is provided an × button appears top-right.
///
/// Tooltip priority (first non-null wins):
/// 1. [tooltip] — any [TooltipIcon] instance.
/// 2. [tooltipTitle] + [tooltipBody] — convenience for [TooltipIcon.titled].
/// 3. [tooltipMsg] — convenience for a plain-text [TooltipIcon].
class MinimalAlert extends StatelessWidget {
  const MinimalAlert({
    required this.message,
    this.tooltipMsg,
    this.tooltipTitle,
    this.tooltipBody,
    this.tooltip,
    this.onDismiss,
    super.key,
  }) : assert(
         tooltipTitle == null || tooltipBody != null,
         'tooltipBody must be provided when tooltipTitle is set.',
       );

  final String message;

  /// Convenience: plain-text tooltip. Ignored when [tooltip] is set.
  final String? tooltipMsg;

  /// Convenience: titled tooltip title. Requires [tooltipBody].
  /// Ignored when [tooltip] is set.
  final String? tooltipTitle;

  /// Convenience: titled tooltip body. Required when [tooltipTitle] is set.
  final String? tooltipBody;

  /// Explicit [TooltipIcon]. Takes priority over [tooltipTitle]/[tooltipMsg].
  final TooltipIcon? tooltip;

  /// Called when the user taps the × dismiss button.
  /// If null, no dismiss button is rendered.
  final VoidCallback? onDismiss;

  TooltipIcon? _effectiveTooltip(Color color) =>
      tooltip ??
      (tooltipTitle != null
          ? TooltipIcon.titled(title: tooltipTitle!, body: tooltipBody!, color: color)
          : (tooltipMsg != null ? TooltipIcon(message: tooltipMsg!, color: color) : null));

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    final theme = Theme.of(context);
    final textColor = palette.textTertiary;
    final effectiveTooltip = _effectiveTooltip(textColor);

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.bgPrimary,
            borderRadius: const BorderRadius.all(Radius.kS),
            border: Border.all(color: palette.borderPrimary),
            boxShadow: [
              BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                // 44px right reserves space for the 36px dismiss button at right: 7
                padding: EdgeInsets.fromLTRB(
                  theme.spacing.md,
                  theme.spacing.md,
                  44,
                  theme.spacing.md,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: message,
                        style: theme.textStyles.textSm.regular.copyWith(color: textColor),
                      ),
                      if (effectiveTooltip != null)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(left: theme.spacing.xs),
                            child: effectiveTooltip,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (onDismiss != null)
                Positioned(
                  top: 7,
                  right: 7,
                  child: IconButton(
                    onPressed: onDismiss,
                    padding: EdgeInsets.zero,
                    icon: Icon(UntitledUI.x_close, size: 20, color: palette.iconTertiary),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.kS)),
                      ),
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
