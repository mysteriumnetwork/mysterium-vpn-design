import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'Default', type: LocationStatusCard)
Widget buildLocationStatusCard(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: BarStatus.values,
    initialOption: BarStatus.connected,
    labelBuilder: (s) => s.name,
  );
  final statusLabel = switch (status) {
    BarStatus.connected => 'Connected',
    BarStatus.disconnected => 'Disconnected',
    _ => 'Getting IP address...',
  };
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LocationStatusCard(
      country: context.knobs.string(label: 'Country', initialValue: 'Germany'),
      city: context.knobs.string(label: 'City', initialValue: 'Berlin'),
      countryIcon: WidgetbookUtils.placeholderFlag(const [
        Color(0xFF000000),
        Color(0xFFDD0000),
        Color(0xFFFFCC00),
      ]),
      status: status,
      statusLabel: context.knobs.string(label: 'Status label', initialValue: statusLabel),
    ),
  );
}
