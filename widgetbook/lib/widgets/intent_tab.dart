import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'IntentTab', type: IntentTab)
Widget buildIntentTab(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: IntentTabStatus.values,
    initialOption: IntentTabStatus.idle,
    labelBuilder: (s) => s.name,
  );
  return Padding(
    padding: const EdgeInsets.all(16),
    child: IntentTab(
      icon: UntitledUI.clock,
      label: context.knobs.string(label: 'Label', initialValue: 'Low latency'),
      status: status,
    ),
  );
}

@UseCase(name: 'Carousel', type: IntentTab)
Widget buildIntentTabCarousel(BuildContext context) {
  final theme = Theme.of(context);
  final palette = theme.palette;
  final headerStyle = theme.textStyles.textMd.semibold.copyWith(color: palette.textTertiary);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text('Speciality server', style: headerStyle),
            Icon(UntitledUI.help_circle, size: 16, color: palette.textTertiary),
          ],
        ),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: [
              IntentTab(icon: UntitledUI.flash, label: 'Best speed'),
              IntentTab(icon: UntitledUI.clock, label: 'Low latency'),
              IntentTab(icon: UntitledUI.marker_pin_04, label: 'Nearest location'),
              IntentTab(icon: UntitledUI.shield_01, label: 'Max privacy'),
              IntentTab(icon: UntitledUI.film_01, label: 'Streaming'),
              IntentTab(icon: UntitledUI.users_02, label: 'P2P'),
            ],
          ),
        ),
      ],
    ),
  );
}
