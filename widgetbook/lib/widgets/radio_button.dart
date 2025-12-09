import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'RadioButton', type: RadioButton)
Widget buildRadioButton(BuildContext context) {
  final isSelected = context.knobs.boolean(label: 'Selected');
  final isDisabled = context.knobs.boolean(label: 'Disabled');
  final radius = context.knobs.int
      .slider(
        label: 'Radius',
        initialValue: 20,
        description: '(1-100)',
        min: 1,
        max: 100,
      )
      .clamp(1, 100);

  return RadioGroup(
    groupValue: true,
    onChanged: (_) {},
    child: RadioButton(
      value: isSelected,
      enabled: !isDisabled,
      radius: radius.toDouble(),
    ),
  );
}
