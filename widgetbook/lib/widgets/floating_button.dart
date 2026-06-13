import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: FloatingButton)
Widget buildFloatingButton(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Skip');
  final isDisabled = context.knobs.boolean(label: 'Disabled');

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Align(
      alignment: Alignment.topRight,
      child: FloatingButton(
        label: label,
        icon: UntitledUI.x_close,
        onPressed: isDisabled ? null : () {},
      ),
    ),
  );
}
