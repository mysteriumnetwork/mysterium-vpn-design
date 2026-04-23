import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'LinkSpan', type: LinkSpan)
Widget buildLinkSpan(BuildContext context) {
  final prefix = context.knobs.string(
    label: 'Prefix',
    initialValue: 'By continuing you agree to our ',
  );
  final linkText = context.knobs.string(label: 'Link text', initialValue: 'Terms of Service');
  final suffix = context.knobs.string(label: 'Suffix', initialValue: '.');
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Text.rich(
      TextSpan(
        style: theme.textStyles.textMd.regular.copyWith(color: theme.palette.textPrimary),
        children: [
          TextSpan(text: prefix),
          LinkSpan(text: linkText, onTap: () {}),
          TextSpan(text: suffix),
        ],
      ),
    ),
  );
}
