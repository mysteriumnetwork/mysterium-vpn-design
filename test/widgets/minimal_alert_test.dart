import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('MinimalAlert', () {
    testWidgets('renders message', (tester) async {
      await pumpWidget(tester, const MinimalAlert(message: 'Your IP is visible'));
      expect(find.text('Your IP is visible'), findsOneWidget);
    });

    testWidgets('shows dismiss button when onDismiss provided', (tester) async {
      var dismissed = false;
      await pumpWidget(tester, MinimalAlert(message: 'Alert', onDismiss: () => dismissed = true));
      expect(find.byType(IconButton), findsOneWidget);
      await tester.tap(find.byType(IconButton));
      expect(dismissed, isTrue);
    });

    testWidgets('hides dismiss button when onDismiss is null', (tester) async {
      await pumpWidget(tester, const MinimalAlert(message: 'No dismiss'));
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('renders with tooltipMsg', (tester) async {
      await pumpWidget(tester, const MinimalAlert(message: 'Alert', tooltipMsg: 'More info'));
      expect(find.byType(TooltipIcon), findsOneWidget);
    });

    testWidgets('renders with titled tooltip', (tester) async {
      await pumpWidget(
        tester,
        const MinimalAlert(message: 'Alert', tooltipTitle: 'Title', tooltipBody: 'Body text'),
      );
      expect(find.byType(TooltipIcon), findsOneWidget);
    });
  });
}
