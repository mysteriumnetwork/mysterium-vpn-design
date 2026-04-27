import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class TooltipIcon extends StatelessWidget {
  const TooltipIcon({
    required String message,
    IconData icon = UntitledUI.help_circle,
    double size = 16.0,
    Color? color,
    Key? key,
  }) : this._(key: key, message: message, icon: icon, size: size, color: color);

  const TooltipIcon.richMessage({
    required InlineSpan message,
    IconData icon = UntitledUI.help_circle,
    double size = 16.0,
    Color? color,
    Key? key,
  }) : this._(key: key, richMessage: message, icon: icon, size: size, color: color);

  /// Shows [content] — any widget — inside the tooltip popup.
  const TooltipIcon.widget({
    required Widget content,
    IconData icon = UntitledUI.help_circle,
    double size = 16.0,
    Color? color,
    Key? key,
  }) : this._(key: key, content: content, icon: icon, size: size, color: color);

  /// Shows a titled tooltip with a [title] (semibold) and [body] (medium),
  /// matching the Figma "Content" tooltip spec.
  TooltipIcon.titled({
    required String title,
    required String body,
    IconData icon = UntitledUI.help_circle,
    double size = 16.0,
    Color? color,
    Key? key,
  }) : this._(
         key: key,
         content: _TitledBody(title: title, body: body),
         icon: icon,
         size: size,
         color: color,
       );

  const TooltipIcon._({
    super.key,
    this.message,
    this.richMessage,
    this.content,
    this.icon = UntitledUI.help_circle,
    this.size = 16.0,
    this.color,
  }) : assert(
         message != null || richMessage != null || content != null,
         'Either message, richMessage, or content must be provided.',
       );

  final String? message;
  final InlineSpan? richMessage;

  /// Custom widget content rendered inside the tooltip.
  final Widget? content;

  final IconData icon;
  final double size;

  /// Icon color. Defaults to [Palette.textTertiary] when null.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveRichMessage = switch ((content, richMessage)) {
      (final Widget w, _) => WidgetSpan(child: w),
      (_, final InlineSpan s) => TextSpan(children: [s]),
      _ => null,
    };

    return Tooltip(
      mouseCursor: SystemMouseCursors.click,
      textAlign: TextAlign.start,
      message: effectiveRichMessage != null ? null : message,
      richMessage: effectiveRichMessage,
      verticalOffset: (size / 2) + 4,
      child: Icon(icon, size: size, color: color ?? theme.palette.textTertiary),
    );
  }
}

// ─── Titled tooltip body ──────────────────────────────────────────────────────

class _TitledBody extends StatelessWidget {
  const _TitledBody({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = theme.palette.textTooltip;
    // Secondary text: tooltip primary at 56% opacity, matching Figma spec.
    final bodyColor = titleColor.withValues(alpha: 0.56);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(title, style: theme.textStyles.textXs.semibold.copyWith(color: titleColor)),
        Text(body, style: theme.textStyles.textXs.medium.copyWith(color: bodyColor)),
      ],
    );
  }
}
