import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: CustomIconButton)
Widget buildIconButton(BuildContext context) {
  final isDisabled = context.knobs.boolean(label: 'Disabled');
  final tooltip = context.knobs.stringOrNull(label: 'Tooltip', initialValue: 'Refresh');
  return Center(
    child: CustomIconButton(
      onPressed: isDisabled ? null : () {},
      icon: const Icon(UntitledUI.refresh_ccw_01),
      tooltip: tooltip,
    ),
  );
}
