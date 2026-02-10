import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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

  final Widget? emblem;
  final double? emblemSpacing;

  final String title;
  final String? description;
  final TextStyle? titleStyle;
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
          Align(
            alignment: Alignment.topCenter,
            child: emblem,
          ),
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
            style: descriptionStyle ??
                theme.textStyles.textMd.regular.copyWith(color: theme.palette.textSecondary),
          ),
        ],
      ],
    );
  }
}
