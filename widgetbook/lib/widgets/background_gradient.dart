import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: BackgroundGradient)
Widget buildBackgroundGradient(BuildContext context) {
  final showGradient = context.knobs.boolean(label: 'Show gradient', initialValue: true);
  final palette = Theme.of(context).palette;

  return ColoredBox(
    color: palette.bgPopover,
    child: BackgroundGradient(
      showGradient: showGradient,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 30,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text('Scrollable content item $index'),
        ),
      ),
    ),
  );
}
