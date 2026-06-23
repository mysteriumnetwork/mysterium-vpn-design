import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: RefreshIconButton)
Widget buildRefreshIconButton(BuildContext context) {
  final spinning = context.knobs.boolean(label: 'Spinning');
  final disabled = context.knobs.boolean(label: 'Disabled');
  final tooltip = context.knobs.stringOrNull(label: 'Tooltip');
  final iconSize = context.knobs.double.slider(
    label: 'Icon size',
    initialValue: 18,
    min: 12,
    max: 32,
  );

  return Center(
    child: RefreshIconButton(
      spinning: spinning,
      tooltip: tooltip,
      iconSize: iconSize,
      onPressed: disabled ? null : () {},
    ),
  );
}
