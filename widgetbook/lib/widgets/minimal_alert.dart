import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ─── Plain text tooltip ───────────────────────────────────────────────────────

@UseCase(name: 'Plain tooltip', type: MinimalAlert)
Widget buildMinimalAlert(BuildContext context) {
  final showTooltip = context.knobs.boolean(label: 'Show tooltip', initialValue: true);
  final showDismiss = context.knobs.boolean(label: 'Show dismiss button', initialValue: true);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: MinimalAlert(
      message: context.knobs.string(
        label: 'Message',
        initialValue:
            'Residential IPs from real households. Nearly undetectable but less stable, so the IP you get might change',
      ),
      tooltipMsg: showTooltip ? 'Residential IPs use real household addresses.' : null,
      onDismiss: showDismiss ? () {} : null,
    ),
  );
}

// ─── Titled tooltip ───────────────────────────────────────────────────────────

@UseCase(name: 'Titled tooltip', type: MinimalAlert)
Widget buildMinimalAlertTitled(BuildContext context) {
  final showDismiss = context.knobs.boolean(label: 'Show dismiss button', initialValue: true);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: MinimalAlert(
      message: context.knobs.string(
        label: 'Message',
        initialValue:
            'Residential IPs from real households. Nearly undetectable but less stable, so the IP you get might change',
      ),
      tooltipTitle: context.knobs.string(
        label: 'Tooltip title',
        initialValue: 'Why does the IP change?',
      ),
      tooltipBody: context.knobs.string(
        label: 'Tooltip body',
        initialValue:
            "Household IPs depend on real people. If their link is lost, you'll be instantly reconnected to the nearest available IP.",
      ),
      onDismiss: showDismiss ? () {} : null,
    ),
  );
}
