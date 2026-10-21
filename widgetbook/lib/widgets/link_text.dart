import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'LinkText', type: LinkText)
Widget buildLinkText(BuildContext context) {
  final prefix = context.knobs.string(
    label: 'Prefix',
    initialValue: 'By continuing you agree to our ',
  );
  final linkText = context.knobs.string(label: 'Link text', initialValue: 'Terms of Service');
  final second = context.knobs.string(label: 'Second link', initialValue: 'Privacy Policy');
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.all(24),
    child: LinkText(
      style: theme.textStyles.textMd.regular.copyWith(color: theme.palette.textPrimary),
      builder: (link) => [
        TextSpan(text: prefix),
        link(linkText, () {}),
        const TextSpan(text: ' and '),
        link(second, () {}),
        const TextSpan(text: '.'),
      ],
    ),
  );
}
