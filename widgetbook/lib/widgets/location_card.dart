import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'LocationCard', type: LocationCard)
Widget buildLocationCard(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: LocationCardStatus.values,
    initialOption: LocationCardStatus.idle,
    labelBuilder: (s) => s.name,
  );
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LocationCard(
      icon: const _DeFlag(),
      name: context.knobs.string(label: 'Name', initialValue: 'Germany'),
      subtitle: context.knobs.string(label: 'Subtitle', initialValue: 'High speed'),
      status: status,
    ),
  );
}

@UseCase(name: 'Carousel', type: LocationCard)
Widget buildLocationCardCarousel(BuildContext context) => const Padding(
  padding: EdgeInsets.all(16),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      spacing: 8,
      children: [
        LocationCard(icon: _DeFlag(), name: 'Germany', subtitle: 'High speed'),
        LocationCard(
          icon: _DeFlag(),
          name: 'Germany',
          subtitle: 'High speed',
          status: LocationCardStatus.selected,
        ),
        LocationCard(
          icon: _DeFlag(),
          name: 'Germany',
          subtitle: 'High speed',
          status: LocationCardStatus.disabled,
        ),
      ],
    ),
  ),
);

// ─── Flag placeholder ─────────────────────────────────────────────────────────

class _DeFlag extends StatelessWidget {
  const _DeFlag();

  @override
  Widget build(BuildContext context) => const ClipOval(
    child: Column(
      children: [
        Expanded(
          child: ColoredBox(color: Color(0xFF000000), child: SizedBox.expand()),
        ),
        Expanded(
          child: ColoredBox(color: Color(0xFFDD0000), child: SizedBox.expand()),
        ),
        Expanded(
          child: ColoredBox(color: Color(0xFFFFCE00), child: SizedBox.expand()),
        ),
      ],
    ),
  );
}
