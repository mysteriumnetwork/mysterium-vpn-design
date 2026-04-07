import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

enum _Plan { free, basic, premium }

const _kHeaders = {_Plan.free: 'Free', _Plan.basic: 'Basic', _Plan.premium: 'Premium'};

const _kFeatures = <ComparisonFeature<_Plan>>[
  ComparisonFeature(
    label: 'Bandwidth',
    values: {
      _Plan.free: ComparisonText('10 GB / mo'),
      _Plan.basic: ComparisonText('Unlimited'),
      _Plan.premium: ComparisonText('Unlimited'),
    },
  ),
  ComparisonFeature(
    label: 'Simultaneous connections',
    values: {
      _Plan.free: ComparisonText('1'),
      _Plan.basic: ComparisonText('5'),
      _Plan.premium: ComparisonText('10'),
    },
  ),
  ComparisonFeature(
    label: 'Access blocked sites',
    values: {
      _Plan.free: ComparisonAvailable(false),
      _Plan.basic: ComparisonAvailable(true),
      _Plan.premium: ComparisonAvailable(true),
    },
  ),
  ComparisonFeature(
    label: 'Ad & tracker blocker',
    values: {
      _Plan.free: ComparisonAvailable(false),
      _Plan.basic: ComparisonAvailable(false),
      _Plan.premium: ComparisonAvailable(true),
    },
  ),
  ComparisonFeature(
    label: 'Kill switch',
    description: 'Blocks internet if VPN disconnects',
    values: {
      _Plan.free: ComparisonAvailable(false),
      _Plan.basic: ComparisonAvailable(true),
      _Plan.premium: ComparisonAvailable(true),
    },
  ),
  ComparisonFeature(
    label: 'Priority support',
    values: {
      _Plan.free: ComparisonAvailable(false),
      _Plan.basic: ComparisonAvailable(false),
      _Plan.premium: ComparisonAvailable(true),
    },
  ),
];

@UseCase(name: 'Default', type: ComparisonTable)
Widget buildComparisonTable(BuildContext context) =>
    const ComparisonTable<_Plan>(headerColumns: _kHeaders, features: _kFeatures);

@UseCase(name: 'With header index column', type: ComparisonTable)
Widget buildComparisonTableWithHeader(BuildContext context) => const ComparisonTable<_Plan>(
  headerColumns: _kHeaders,
  headerIndexColumn: Text('Feature'),
  features: _kFeatures,
);
