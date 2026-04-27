import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Title block for a modal: an optional centred [emblem] above a [title]
/// and optional [description].
///
/// Intended to sit at the top of a [ModalScaffold] body.
class ModalHeader extends StatelessWidget {
  const ModalHeader({
    required this.title,
    this.emblem,
    this.description,
    this.emblemSpacing,
    this.titleStyle,
    this.descriptionStyle,
    super.key,
  });

  /// Optional centred glyph / illustration above the title.
  final Widget? emblem;

  /// Gap between [emblem] and [title]. Defaults to `theme.spacing.xl3`.
  final double? emblemSpacing;

  /// Heading text. Capped at 2 lines.
  final String title;

  /// Optional subtitle rendered under the title. Capped at 2 lines.
  final String? description;

  /// Overrides the default display-xl / bold title style.
  final TextStyle? titleStyle;

  /// Overrides the default text-md / regular description style.
  final TextStyle? descriptionStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emblemSpacing = this.emblemSpacing ?? theme.spacing.xl3;
    return Column(
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
          style: titleStyle ?? theme.textStyles.displayXlg.bold,
        ),
        if (description != null) ...[
          SizedBox(height: theme.spacing.s),
          Text(
            description!,
            textAlign: TextAlign.center,
            maxLines: 2,
            style:
                descriptionStyle ??
                theme.textStyles.textMd.regular.copyWith(color: theme.palette.textSecondary),
          ),
        ],
      ],
    );
  }
}
