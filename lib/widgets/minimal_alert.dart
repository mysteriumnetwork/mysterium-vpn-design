import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A dismissible informational banner with optional tooltip.
///
/// Shows [message] in a styled card. When [title] is set the card renders a
/// bold title line with [message] as supporting text below it, and any tooltip
/// is placed beside the title. Otherwise [message] is shown on its own and the
/// tooltip is rendered inline after it.
///
/// When a tooltip is provided an [info-circle] [TooltipIcon] is rendered.
/// When [onDismiss] is provided an × button appears top-right.
///
/// Tooltip priority (first non-null wins):
/// 1. [tooltip] — any [TooltipIcon] instance.
/// 2. [tooltipTitle] + [tooltipBody] — convenience for [TooltipIcon.titled].
/// 3. [tooltipMsg] — convenience for a plain-text [TooltipIcon].
class MinimalAlert extends StatelessWidget {
  const MinimalAlert({
    required this.message,
    this.title,
    this.titleAction,
    this.leadingIcon,
    this.tooltipMsg,
    this.tooltipTitle,
    this.tooltipBody,
    this.tooltip,
    this.onDismiss,
    super.key,
  }) : assert(
         tooltipTitle == null || tooltipBody != null,
         'tooltipBody must be provided when tooltipTitle is set.',
       ),
       assert(titleAction == null || title != null, 'titleAction requires a title.');

  final String message;

  /// Optional bold title rendered above [message]. When set, [message] becomes
  /// supporting text, any tooltip is placed beside the title, and the leading
  /// icon aligns to the top of the content (instead of vertically centered).
  final String? title;

  /// Optional widget rendered beside [title] instead of the built-in tooltip
  /// icon — e.g. a tappable info icon that opens a custom popover. Takes
  /// precedence over the tooltip when both are provided. Requires [title].
  final Widget? titleAction;

  /// Optional glyph rendered in a circular informational badge before the
  /// message. Matches the "Minimal alert/Default" component in Figma.
  final IconData? leadingIcon;

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
    final hasTitle = title != null;

    // 44px right reserves space for the 36px dismiss button at right: 7.
    final rightPad = onDismiss != null ? 44.0 : theme.spacing.ms;

    final content = hasTitle
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title!,
                      style: theme.textStyles.textSm.semibold.copyWith(color: palette.textPrimary),
                    ),
                  ),
                  if (titleAction != null)
                    Padding(
                      padding: EdgeInsets.only(left: theme.spacing.s),
                      child: titleAction,
                    )
                  else if (effectiveTooltip != null)
                    Padding(
                      padding: EdgeInsets.only(left: theme.spacing.s),
                      child: effectiveTooltip,
                    ),
                ],
              ),
              SizedBox(height: theme.spacing.xxs),
              Text(message, style: theme.textStyles.textXs.regular.copyWith(color: textColor)),
            ],
          )
        : Text.rich(
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
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.bgPrimary,
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: palette.borderPrimary),
        boxShadow: [BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              theme.spacing.ms,
              theme.spacing.ms,
              rightPad,
              theme.spacing.ms,
            ),
            child: Row(
              crossAxisAlignment: hasTitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  DecoratedIcon(
                    icon: leadingIcon!,
                    decoration: IconDecoration(
                      backgroundColor: palette.bgSecondary,
                      iconColor: palette.iconTertiary,
                      iconSize: 20,
                      padding: const EdgeInsets.all(6),
                      borderRadius: const BorderRadius.all(Radius.kFull),
                    ),
                  ),
                  SizedBox(width: theme.spacing.s),
                ],
                Expanded(child: content),
              ],
            ),
          ),
          if (onDismiss != null)
            Positioned(
              top: 7,
              right: 7,
              child: SizedBox.square(
                dimension: 36,
                child: IconButton(
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  icon: Icon(UntitledUI.x_close, size: 20, color: palette.iconTertiary),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.kXs)),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
