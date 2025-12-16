import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({
    required this.emblem,
    required this.title,
    this.description,
    this.emblemSpacing,
    super.key,
  });

  final Widget emblem;
  final double? emblemSpacing;

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emblemSpacing = this.emblemSpacing ?? theme.spacing.xl3;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: emblem,
        ),
        SizedBox(height: emblemSpacing),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: theme.textStyles.displayXlg.bold,
        ),
        if (description != null) ...[
          SizedBox(height: theme.spacing.s),
          Text(
            description!,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: theme.textStyles.textMd.regular.copyWith(color: theme.palette.textSecondary),
          ),
        ],
      ],
    );
  }
}
