import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ProgressBar', type: ProgressBar)
Widget buildProgressIndicator(BuildContext context) {
  final type = context.knobs.object.dropdown(
    label: 'Type',
    options: ProgressBarType.values,
    initialOption: ProgressBarType.circular,
  );

  final value = context.knobs.double.slider(label: 'Value', initialValue: 0.5, min: 0, max: 1);
  final width = context.knobs.double.input(label: 'Width', initialValue: 100);
  final height = context.knobs.double.input(label: 'Height', initialValue: 100);
  final backgroundColor = context.knobs.color(label: 'Background color', initialValue: Colors.grey);
  final color = context.knobs.color(label: 'Color', initialValue: Colors.blue);

  return ProgressBar(
    type: type,
    value: value,
    width: width,
    height: height,
    backgroundColor: backgroundColor,
    color: color,
  );
}
