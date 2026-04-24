import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ModalPadding', type: ModalPadding)
Widget buildModalPadding(BuildContext context) {
  final extra = context.knobs.double.slider(label: 'Extra top padding', initialValue: 16, max: 80);
  return ModalPadding(
    add: EdgeInsets.only(top: extra),
    child: Container(
      color: Theme.of(context).palette.bgSecondary,
      height: 200,
      alignment: Alignment.center,
      child: const Text('Padded child'),
    ),
  );
}
