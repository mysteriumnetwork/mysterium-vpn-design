import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ─── Inactive ─────────────────────────────────────────────────────────────────

@UseCase(name: 'Inactive', type: MapLocationMarker)
Widget buildMapLocationMarkerInactive(BuildContext context) =>
    const Center(child: MapLocationMarker(onPressed: _noop));

// ─── Selected ─────────────────────────────────────────────────────────────────

@UseCase(name: 'Selected', type: MapLocationMarker)
Widget buildMapLocationMarkerSelected(BuildContext context) =>
    Center(child: MapLocationMarker(isSelected: true, onPressed: () {}));

// ─── Connected ────────────────────────────────────────────────────────────────

@UseCase(name: 'Connected', type: MapLocationMarker)
Widget buildMapLocationMarkerConnected(BuildContext context) =>
    Center(child: MapLocationMarker(isConnected: true, onPressed: () {}));

// ─── Tooltip ──────────────────────────────────────────────────────────────────

@UseCase(name: 'Tooltip', type: MapLocationTooltip)
Widget buildMapLocationTooltip(BuildContext context) => Center(
  child: MapLocationTooltip(
    label: context.knobs.string(label: 'Label', initialValue: 'Netherlands'),
  ),
);

void _noop() {}
