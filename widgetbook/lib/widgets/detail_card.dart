import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Single', type: DetailCard)
Widget buildDetailCardSingle(BuildContext context) => Padding(
  padding: const EdgeInsets.all(16),
  child: DetailCard(
    title: context.knobs.string(label: 'Title', initialValue: 'VPN IP'),
    value: context.knobs.string(label: 'Value', initialValue: '195.285.15.404'),
    valueMuted: context.knobs.boolean(label: 'Muted value'),
  ),
);

@UseCase(name: 'Grouped list', type: DetailCard)
Widget buildDetailCardGroup(BuildContext context) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DetailCard(
          title: 'My IP',
          value: 'Hidden',
          valueMuted: true,
          valueIcon: Icon(UntitledUI.eye_off, size: 24),
          position: SettingsCardPosition.top,
        ),
        const DetailCard(
          title: 'VPN IP',
          value: '195.285.15.404',
          position: SettingsCardPosition.middle,
        ),
        DetailCard(
          title: 'IP pool',
          value: '4',
          position: SettingsCardPosition.bottom,
          trailing: ButtonTertiary(
            onPressed: () {},
            size: ButtonSize.small,
            decoration: ButtonDecoration(
              foregroundColor: theme.palette.textBrandPrimary,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            leading: const Icon(UntitledUI.refresh_cw_02, size: 20),
            child: const Text('Refresh'),
          ),
        ),
      ],
    ),
  );
}
