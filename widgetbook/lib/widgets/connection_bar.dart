import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ConnectionBar', type: ConnectionBar)
Widget buildConnectionBar(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    initialOption: BarStatus.disconnected,
    options: BarStatus.values,
    labelBuilder: (s) => s.name,
  );
  final label = context.knobs.string(
    label: 'Label',
    initialValue: switch (status) {
      BarStatus.connected => 'Connected',
      BarStatus.disconnected => 'Disconnected',
      BarStatus.gettingIp => 'Getting IP address',
    },
  );
  final killSwitchLabel = context.knobs.string(
    label: 'Kill switch label',
    initialValue: 'Kill switch:',
  );
  final killSwitchDescription = context.knobs.string(
    label: 'Kill switch description',
    initialValue:
        'Blocks internet traffic when connection to a vpn server is lost. '
        'Kill-switch is always on when you connect to MysteriumVPN.',
  );

  return ConnectionBar(
    label: label,
    status: status,
    killSwitchLabel: killSwitchLabel,
    killSwitchDescription: killSwitchDescription,
  );
}
