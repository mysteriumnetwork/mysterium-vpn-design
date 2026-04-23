import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'CharacterSpan', type: CharacterSpan)
Widget buildCharacterSpan(BuildContext context) {
  final theme = Theme.of(context);
  final style = theme.textStyles.textMd.regular.copyWith(color: theme.palette.textPrimary);
  final rows = <({String label, List<InlineSpan> spans})>[
    (
      label: 'space',
      spans: [
        const TextSpan(text: 'left'),
        CharacterSpan.space(),
        const TextSpan(text: 'right'),
      ],
    ),
    (
      label: 'slash',
      spans: [
        const TextSpan(text: r'$9.99'),
        CharacterSpan.slash(),
        const TextSpan(text: 'mo'),
      ],
    ),
    (
      label: 'hyphen',
      spans: [
        const TextSpan(text: 'A'),
        CharacterSpan.hyphen(),
        const TextSpan(text: 'B'),
      ],
    ),
    (
      label: 'percent',
      spans: [
        const TextSpan(text: '20'),
        CharacterSpan.percent(),
        const TextSpan(text: ' off'),
      ],
    ),
    (
      label: 'bullet',
      spans: [
        const TextSpan(text: 'one'),
        CharacterSpan.bullet(),
        const TextSpan(text: 'two'),
      ],
    ),
    (
      label: 'newline',
      spans: [
        const TextSpan(text: 'first'),
        CharacterSpan.newline(),
        const TextSpan(text: 'second'),
      ],
    ),
  ];
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        for (final row in rows)
          Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(row.label, style: style.copyWith(color: theme.palette.textSecondary)),
              ),
              Expanded(
                child: Text.rich(TextSpan(children: row.spans), style: style),
              ),
            ],
          ),
      ],
    ),
  );
}
