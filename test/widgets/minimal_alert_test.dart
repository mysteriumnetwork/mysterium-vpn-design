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

    testWidgets('renders leading icon when provided', (tester) async {
      await pumpWidget(
        tester,
        const MinimalAlert(message: 'Alert', leadingIcon: UntitledUI.info_circle),
      );
      expect(find.byIcon(UntitledUI.info_circle), findsOneWidget);
    });

    testWidgets('omits leading icon when null', (tester) async {
      await pumpWidget(tester, const MinimalAlert(message: 'Alert'));
      expect(find.byIcon(UntitledUI.info_circle), findsNothing);
    });

    testWidgets('renders title and message when title provided', (tester) async {
      await pumpWidget(
        tester,
        const MinimalAlert(title: 'High-speed IPs', message: 'Optimised for speed.'),
      );
      expect(find.text('High-speed IPs'), findsOneWidget);
      expect(find.text('Optimised for speed.'), findsOneWidget);
    });

    testWidgets('renders tooltip beside title when titled', (tester) async {
      await pumpWidget(
        tester,
        const MinimalAlert(
          title: 'Residential IPs',
          message: 'Provided by real households.',
          tooltipTitle: 'Title',
          tooltipBody: 'Body text',
        ),
      );
      expect(find.byType(TooltipIcon), findsOneWidget);
    });

    testWidgets('titleAction replaces the tooltip beside the title', (tester) async {
      await pumpWidget(
        tester,
        const MinimalAlert(
          title: 'Residential IPs',
          message: 'Provided by real households.',
          tooltipTitle: 'Title',
          tooltipBody: 'Body text',
          titleAction: Icon(UntitledUI.info_circle, key: Key('action')),
        ),
      );
      expect(find.byKey(const Key('action')), findsOneWidget);
      expect(find.byType(TooltipIcon), findsNothing);
    });
  });
}
