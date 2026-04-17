import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('IntentTab', () {
    testWidgets('renders icon and label', (tester) async {
      await pumpWidget(tester, const IntentTab(icon: Icons.speed, label: 'Low latency'));
      expect(find.text('Low latency'), findsOneWidget);
      expect(find.byIcon(Icons.speed), findsOneWidget);
    });

    testWidgets('calls onTap when idle', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        IntentTab(icon: Icons.speed, label: 'Tap me', onTap: () => tapped = true),
      );
      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        IntentTab(
          icon: Icons.speed,
          label: 'Disabled',
          status: IntentTabStatus.disabled,
          onTap: () => tapped = true,
        ),
      );
      await tester.tap(find.text('Disabled'));
      expect(tapped, isFalse);
    });

    testWidgets('all statuses render without error', (tester) async {
      for (final status in IntentTabStatus.values) {
        await pumpWidget(tester, IntentTab(icon: Icons.speed, label: status.name, status: status));
        expect(find.text(status.name), findsOneWidget);
      }
    });
  });
}
