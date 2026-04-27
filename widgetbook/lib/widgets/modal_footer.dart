import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ModalFooter', type: ModalFooter)
Widget buildModalFooter(BuildContext context) {
  final showSecondary = context.knobs.boolean(label: 'Show secondary button', initialValue: true);
  return Align(
    alignment: Alignment.bottomCenter,
    child: ModalFooter(
      children: [
        ButtonPrimary(onPressed: () {}, child: const Text('Continue')),
        if (showSecondary) ButtonSecondary(onPressed: () {}, child: const Text('Cancel')),
      ],
    ),
  );
}
