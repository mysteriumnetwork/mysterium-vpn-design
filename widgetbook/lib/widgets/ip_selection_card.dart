import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ─── ExpandableIpCard ─────────────────────────────────────────────────────────

@UseCase(name: 'Uncontrolled', type: ExpandableIpCard)
Widget buildExpandableIpCard(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: IpCardStatus.values,
    initialOption: IpCardStatus.idle,
    labelBuilder: (s) => s.name,
  );
  final plusUpgrade = context.knobs.boolean(label: 'Plus upgrade');
  final initiallyExpanded = context.knobs.boolean(label: 'Initially expanded');
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ExpandableIpCard(
      name: 'United States',
      subtitle: '3 states',
      countryIcon: const _UsFlag(),
      status: status,
      plusUpgrade: plusUpgrade,
      initiallyExpanded: initiallyExpanded,
      items: const [
        IpCardItem(name: 'Illinois', subtitle: '4 IPs', status: IpCardStatus.connected),
        IpCardItem(name: 'New York', subtitle: '89 IPs'),
        IpCardItem(name: 'California', subtitle: '120 IPs'),
      ],
    ),
  );
}

@UseCase(name: 'Controlled', type: ExpandableIpCard)
Widget buildExpandableIpCardControlled(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: IpCardStatus.values,
    initialOption: IpCardStatus.idle,
    labelBuilder: (s) => s.name,
  );
  final expanded = context.knobs.boolean(label: 'Expanded');
  final plusUpgrade = context.knobs.boolean(label: 'Plus upgrade');
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ExpandableIpCard(
      name: 'United States',
      subtitle: '3 states',
      countryIcon: const _UsFlag(),
      status: status,
      plusUpgrade: plusUpgrade,
      expanded: expanded,
      items: const [
        IpCardItem(name: 'Illinois', subtitle: '4 IPs', status: IpCardStatus.connected),
        IpCardItem(name: 'New York', subtitle: '89 IPs'),
        IpCardItem(name: 'California', subtitle: '120 IPs'),
      ],
    ),
  );
}

// ─── Flag placeholder ─────────────────────────────────────────────────────────

class _UsFlag extends StatelessWidget {
  const _UsFlag();

  @override
  Widget build(BuildContext context) => const ClipOval(
    child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ColoredBox(color: Color(0xFF3C3B6E), child: SizedBox.expand()),
              ),
              Expanded(
                child: ColoredBox(color: Color(0xFFB22234), child: SizedBox.expand()),
              ),
            ],
          ),
        ),
        Expanded(
          child: ColoredBox(color: Color(0xFFB22234), child: SizedBox.expand()),
        ),
        Expanded(
          child: ColoredBox(color: Colors.white, child: SizedBox.expand()),
        ),
      ],
    ),
  );
}
