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

// ─── Leading icon ─────────────────────────────────────────────────────────────

@UseCase(name: 'Leading icon', type: MinimalAlert)
Widget buildMinimalAlertLeadingIcon(BuildContext context) {
  final showDismiss = context.knobs.boolean(label: 'Show dismiss button', initialValue: true);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: MinimalAlert(
      leadingIcon: UntitledUI.info_circle,
      message: context.knobs.string(
        label: 'Message',
        initialValue: 'Your IP is currently visible. Connect to a server to hide it.',
      ),
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

// ─── Title with leading icon ──────────────────────────────────────────────────

@UseCase(name: 'Title and icon', type: MinimalAlert)
Widget buildMinimalAlertTitledWithIcon(BuildContext context) {
  final showTooltip = context.knobs.boolean(label: 'Show tooltip', initialValue: true);
  final showDismiss = context.knobs.boolean(label: 'Show dismiss button', initialValue: true);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: MinimalAlert(
      leadingIcon: UntitledUI.home_03,
      title: context.knobs.string(label: 'Title', initialValue: 'Residential IPs'),
      message: context.knobs.string(
        label: 'Message',
        initialValue: 'Provided by real households. Nearly undetectable but less stable.',
      ),
      tooltipTitle: showTooltip ? 'Why can my IP change?' : null,
      tooltipBody: showTooltip
          ? 'Residential IPs are provided by real household devices, so availability can change over time.'
          : null,
      onDismiss: showDismiss ? () {} : null,
    ),
  );
}
