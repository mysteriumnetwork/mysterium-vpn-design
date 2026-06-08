import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ─── Embedded content ─────────────────────────────────────────────────────────

@UseCase(name: 'Content', type: InfoPopover)
Widget buildInfoPopover(BuildContext context) {
  final showAction = context.knobs.boolean(label: 'Show action button', initialValue: true);
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: InfoPopover(
        title: context.knobs.string(label: 'Title', initialValue: 'Why does the IP change?'),
        body: context.knobs.string(
          label: 'Body',
          initialValue:
              "Household IPs depend on real people. If their link is lost, you'll be instantly "
              'reconnected to the nearest available IP.',
        ),
        actionLabel: showAction ? 'Got it' : null,
        onAction: showAction ? () {} : null,
      ),
    ),
  );
}

// ─── Anchored overlay ─────────────────────────────────────────────────────────

@UseCase(name: 'Anchored (showInfoPopover)', type: InfoPopover)
Widget buildInfoPopoverAnchored(BuildContext context) => const _AnchoredInfoPopoverDemo();

class _AnchoredInfoPopoverDemo extends StatefulWidget {
  const _AnchoredInfoPopoverDemo();

  @override
  State<_AnchoredInfoPopoverDemo> createState() => _AnchoredInfoPopoverDemoState();
}

class _AnchoredInfoPopoverDemoState extends State<_AnchoredInfoPopoverDemo> {
  final _anchorKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Center(
    child: TextButton(
      key: _anchorKey,
      onPressed: () => showInfoPopover(
        context: context,
        anchorKey: _anchorKey,
        title: 'Why does the IP change?',
        body:
            "Household IPs depend on real people. If their link is lost, you'll be instantly "
            'reconnected to the nearest available IP.',
        actionLabel: 'Got it',
      ),
      child: const Text('Show popover'),
    ),
  );
}
