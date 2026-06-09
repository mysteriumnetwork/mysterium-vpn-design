import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Compact app dialog content for flows that are wrapped by the app.
///
/// This widget intentionally does not call [showDialog] and does not return a
/// [Dialog]. Callers can place it inside their own dialog route/frame while the
/// design system owns the inner size, padding, header typography, and stacked
/// action layout.
class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    this.description,
    this.emblem,
    this.emblemSpacing,
    this.titleStyle,
    this.descriptionStyle,
    this.primaryButton,
    this.secondaryButton,
    this.width,
    this.height,
    super.key,
  });

  /// Heading text shown in the center of the dialog body. Capped at 2 lines.
  final String title;

  /// Optional supporting text rendered under [title]. Capped at 2 lines.
  final String? description;

  /// Optional centered icon, illustration, or badge above [title].
  final Widget? emblem;

  /// Gap between [emblem] and [title]. Defaults to `theme.spacing.md`.
  final double? emblemSpacing;

  /// Overrides the default text-md / semibold title style.
  final TextStyle? titleStyle;

  /// Overrides the default text-xs / regular description style.
  final TextStyle? descriptionStyle;

  /// Primary CTA. Rendered full width above [secondaryButton].
  final Widget? primaryButton;

  /// Secondary CTA. Rendered full width below [primaryButton].
  final Widget? secondaryButton;

  /// Optional dialog content width provided by the caller.
  final double? width;

  /// Optional dialog content height provided by the caller.
  final double? height;

  bool get _hasButtons => primaryButton != null || secondaryButton != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final emblemSpacing = this.emblemSpacing ?? theme.spacing.md;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (emblem != null) ...[
          Align(alignment: Alignment.topCenter, child: emblem),
          SizedBox(height: emblemSpacing),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          style:
              titleStyle ?? theme.textStyles.textMd.semibold.copyWith(color: palette.textPrimary),
        ),
        if (description != null) ...[
          SizedBox(height: theme.spacing.s),
          Text(
            description!,
            textAlign: TextAlign.center,
            maxLines: 2,
            style:
                descriptionStyle ??
                theme.textStyles.textXs.regular.copyWith(color: palette.textTertiary),
          ),
        ],
      ],
    );

    final buttons = _hasButtons
        ? Column(
            children: [
              SizedBox(height: theme.spacing.xl2),
              if (primaryButton != null) Row(children: [Expanded(child: primaryButton!)]),
              if (secondaryButton != null) ...[
                SizedBox(height: theme.spacing.s),
                Row(children: [Expanded(child: secondaryButton!)]),
              ],
            ],
          )
        : null;

    return Material(
      child: Container(
        color: palette.bgModals,
        width: width,
        height: height,
        child: Padding(
          padding: EdgeInsets.all(theme.spacing.md),
          child: Column(mainAxisSize: MainAxisSize.min, children: [content, ?buttons]),
        ),
      ),
    );
  }
}
