import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('ComparisonTable', () {
    testWidgets('renders column headers and feature rows', (tester) async {
      await pumpWidget(
        tester,
        const ComparisonTable<String>(
          headerColumns: {'free': 'Free', 'plus': 'Plus'},
          features: [
            ComparisonFeature<String>(
              label: 'Bandwidth',
              values: {'free': ComparisonText('5 GB'), 'plus': ComparisonText('Unlimited')},
            ),
          ],
        ),
      );
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Plus'), findsOneWidget);
      expect(find.text('Bandwidth'), findsOneWidget);
      expect(find.text('5 GB'), findsOneWidget);
      expect(find.text('Unlimited'), findsOneWidget);
    });

    testWidgets('renders check and cross icons for ComparisonAvailable', (tester) async {
      await pumpWidget(
        tester,
        const ComparisonTable<String>(
          headerColumns: {'free': 'Free', 'plus': 'Plus'},
          features: [
            ComparisonFeature<String>(
              label: 'Priority support',
              values: {'free': ComparisonAvailable(false), 'plus': ComparisonAvailable(true)},
            ),
          ],
        ),
      );
      expect(find.byIcon(UntitledUI.check_circle), findsOneWidget);
      expect(find.byIcon(UntitledUI.x_close), findsOneWidget);
    });

    testWidgets('renders arbitrary widget cell via ComparisonWidget', (tester) async {
      await pumpWidget(
        tester,
        const ComparisonTable<String>(
          headerColumns: {'free': 'Free'},
          features: [
            ComparisonFeature<String>(
              label: 'Custom',
              values: {'free': ComparisonWidget(Text('Widget cell'))},
            ),
          ],
        ),
      );
      expect(find.text('Widget cell'), findsOneWidget);
    });

    testWidgets('renders headerIndexColumn when provided', (tester) async {
      await pumpWidget(
        tester,
        const ComparisonTable<String>(
          headerIndexColumn: Text('Feature'),
          headerColumns: {'free': 'Free'},
          features: [
            ComparisonFeature<String>(label: 'Row', values: {'free': ComparisonText('yes')}),
          ],
        ),
      );
      expect(find.text('Feature'), findsOneWidget);
    });
  });
}
