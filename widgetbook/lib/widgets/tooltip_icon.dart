import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ─── Plain text ───────────────────────────────────────────────────────────────

@UseCase(name: 'Text', type: TooltipIcon)
Widget buildTooltipIconText(BuildContext context) => const Padding(
  padding: EdgeInsets.all(32),
  child: TooltipIcon(message: 'This is a plain text tooltip.'),
);

// ─── Rich message ─────────────────────────────────────────────────────────────

@UseCase(name: 'Rich message', type: TooltipIcon)
Widget buildTooltipIconRich(BuildContext context) => const Padding(
  padding: EdgeInsets.all(32),
  child: TooltipIcon.richMessage(
    message: TextSpan(
      children: [
        TextSpan(
          text: 'Bold label',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' — supporting description text.'),
      ],
    ),
  ),
);

// ─── Titled ───────────────────────────────────────────────────────────────────

@UseCase(name: 'Titled', type: TooltipIcon)
Widget buildTooltipIconTitled(BuildContext context) => Padding(
  padding: const EdgeInsets.all(32),
  child: TooltipIcon.titled(
    title: 'Why the link is lost?',
    body:
        "Household IPs depend on real people. If their link is lost, you'll be instantly reconnected to the nearest available IP. For a stable connection, choose high-speed IPs.",
  ),
);

// ─── Widget content ───────────────────────────────────────────────────────────

@UseCase(name: 'Widget content', type: TooltipIcon)
Widget buildTooltipIconWidget(BuildContext context) => const Padding(
  padding: EdgeInsets.all(32),
  child: TooltipIcon.widget(content: _SampleTooltipBody()),
);

class _SampleTooltipBody extends StatelessWidget {
  const _SampleTooltipBody();

  @override
  Widget build(BuildContext context) => const Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      _Row(label: 'Best speed', description: 'Fastest available server'),
      _Row(label: 'Low latency', description: 'Lowest ping server'),
      _Row(label: 'Nearest location', description: 'Closest server to you'),
      _Row(label: 'Max privacy', description: 'Most private routing'),
      _Row(label: 'Streaming', description: 'Optimised for streaming'),
      _Row(label: 'P2P', description: 'Peer-to-peer optimised'),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.description});

  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label, style: theme.textStyles.textXs.semibold),
          const TextSpan(text: ' — '),
          TextSpan(text: description, style: theme.textStyles.textXs.regular),
        ],
      ),
    );
  }
}
