import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('InfoPopover', () {
    testWidgets('renders title, body and action', (tester) async {
      await pumpWidget(
        tester,
        InfoPopover(
          title: 'Why can my IP change?',
          body: 'Para one.\n\nPara two.',
          actionLabel: 'Got it',
          onAction: () {},
        ),
      );
      expect(find.text('Why can my IP change?'), findsOneWidget);
      expect(find.text('Para one.\n\nPara two.'), findsOneWidget);
      expect(find.text('Got it'), findsOneWidget);
    });

    testWidgets('invokes onAction when tapped', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        InfoPopover(title: 'T', body: 'B', actionLabel: 'Got it', onAction: () => tapped = true),
      );
      await tester.tap(find.text('Got it'));
      expect(tapped, isTrue);
    });

    testWidgets('omits the action button when no label is given', (tester) async {
      await pumpWidget(tester, const InfoPopover(title: 'T', body: 'B'));
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('renders on dark theme without error', (tester) async {
      await pumpWidget(
        tester,
        const InfoPopover(title: 'T', body: 'B', actionLabel: 'Got it'),
        theme: DesignSystem.darkTheme,
      );
      expect(find.byType(InfoPopover), findsOneWidget);
    });
  });

  group('showInfoPopover', () {
    Widget anchorHarness(GlobalKey anchorKey, {required void Function(BuildContext) onReady}) =>
        Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              key: anchorKey,
              onPressed: () => onReady(context),
              child: const Text('anchor'),
            ),
          ),
        );

    testWidgets('shows popover then dismisses on barrier tap', (tester) async {
      final anchorKey = GlobalKey();
      var dismissed = false;
      await pumpWidget(
        tester,
        anchorHarness(
          anchorKey,
          onReady: (context) => showInfoPopover(
            context: context,
            anchorKey: anchorKey,
            title: 'Why can my IP change?',
            body: 'Body.',
            actionLabel: 'Got it',
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.tap(find.text('anchor'));
      await tester.pumpAndSettle();
      expect(find.text('Why can my IP change?'), findsOneWidget);

      // Tap the top-left corner (barrier, away from the centered popover).
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Why can my IP change?'), findsNothing);
      expect(dismissed, isTrue);
    });

    testWidgets('dismisses on Got it', (tester) async {
      final anchorKey = GlobalKey();
      await pumpWidget(
        tester,
        anchorHarness(
          anchorKey,
          onReady: (context) => showInfoPopover(
            context: context,
            anchorKey: anchorKey,
            title: 'Why can my IP change?',
            body: 'Body.',
            actionLabel: 'Got it',
          ),
        ),
      );
      await tester.tap(find.text('anchor'));
      await tester.pumpAndSettle();
      expect(find.text('Got it'), findsOneWidget);
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
      expect(find.text('Why can my IP change?'), findsNothing);
    });
  });
}
