import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ComparisonTable', type: ComparisonTable)
Widget buildFeaturesTable(BuildContext context) =>
    const ComparisonTable<String>(
      headerIndexColumn: Text('Features'),
      headerColumns: {'basic': 'Basic', 'pro': 'Pro'},
      features: [
        ComparisonFeature<String>(
          label: 'Feature A',
          values: {
            'basic': ComparisonAvailable(true),
            'pro': ComparisonAvailable(true),
          },
        ),
        ComparisonFeature<String>(
          label: 'Feature B',
          values: {
            'basic': ComparisonAvailable(false),
            'pro': ComparisonAvailable(true),
          },
        ),
        ComparisonFeature<String>(
          label: 'Feature C',
          values: {
            'basic': ComparisonText('Limited'),
            'pro': ComparisonText('Unlimited'),
          },
        ),
      ],
    );
