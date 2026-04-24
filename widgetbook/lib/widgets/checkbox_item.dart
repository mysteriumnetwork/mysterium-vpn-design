import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'CheckboxItem', type: CheckboxItem)
Widget buildCheckboxItem(BuildContext context) {
  final value = context.knobs.boolean(label: 'Value');
  final readOnly = context.knobs.boolean(label: 'Read-only');
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'I agree to the terms and conditions',
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: CheckboxItem(value: value, onChanged: readOnly ? null : () {}, label: Text(label)),
  );
}
