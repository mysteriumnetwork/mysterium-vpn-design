import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'DecoratedIcon', type: DecoratedIcon)
Widget buildDecoratedIcon(BuildContext context) {
  final decoration = IconDecoration(
    iconColor: context.knobs.color(label: 'Icon color', initialValue: Palette.brand),
    backgroundColor: context.knobs.colorOrNull(
      label: 'Background color',
      initialValue: Palette.white,
    ),
    iconSize: context.knobs.int
        .slider(label: 'Icon size', min: 6, max: 64, initialValue: 32)
        .toDouble(),
    padding: EdgeInsets.all(
      context.knobs.int.slider(label: 'Padding', max: 16, initialValue: 8).toDouble(),
    ),
    borderRadius: BorderRadius.circular(
      context.knobs.int.slider(label: 'Border radius', max: 32, initialValue: 10).toDouble(),
    ),
  );

  return DecoratedIcon(
    icon: context.knobs.object.dropdown(
      label: 'Icon',
      options: WidgetbookUtils.icons,
      labelBuilder: WidgetbookUtils.iconName,
    ),
    decoration: decoration,
  );
}
