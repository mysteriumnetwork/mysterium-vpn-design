import 'package:flutter/material.dart' hide Typography;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart'
    hide DesignSystem;

class Typography extends StatelessWidget {
  const Typography({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textStyles;
    final fontName = typography.displayXlg.regular.fontFamily ?? 'Unknown';

    final styles = {
      'Display xlg': [
        typography.displayXlg.regular,
        typography.displayXlg.medium,
        typography.displayXlg.semibold,
        typography.displayXlg.bold,
      ],
      'Text lg': [
        typography.textLg.regular,
        typography.textLg.medium,
        typography.textLg.semibold,
        typography.textLg.bold,
      ],
      'Text md': [
        typography.textMd.regular,
        typography.textMd.medium,
        typography.textMd.semibold,
        typography.textMd.bold,
      ],
      'Text sm': [
        typography.textSm.regular,
        typography.textSm.medium,
        typography.textSm.semibold,
        typography.textSm.bold,
      ],
      'Text xs': [
        typography.textXs.regular,
        typography.textXs.medium,
        typography.textXs.semibold,
        typography.textXs.bold,
      ],
    };

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(theme.spacing.xl),
            child: Text(fontName, style: typography.displayXlg.regular),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(theme.spacing.xl),
              itemCount: styles.length * 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (_, index) {
                final styleCategory = styles.keys.elementAt(index ~/ 4);
                final styleList = styles[styleCategory]!;
                final style = styleList[index % 4];
                final modifier = switch (index % 4) {
                  0 => 'Regular',
                  1 => 'Medium',
                  2 => 'Semibold',
                  3 => 'Bold',
                  _ => 'Unknown',
                };
                return _Entry(
                  name: styleCategory,
                  modifier: modifier,
                  style: style,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({
    required this.name,
    required this.modifier,
    required this.style,
  });

  final String name;
  final String modifier;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(name, style: style, overflow: TextOverflow.ellipsis),
      Flexible(
        child: Text(modifier, style: style, overflow: TextOverflow.ellipsis),
      ),
    ],
  );
}
