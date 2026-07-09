import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('PromptDialog', () {
    testWidgets('renders image, title, and subtitle', (tester) async {
      await pumpWidget(
        tester,
        const PromptDialog(
          image: Icon(Icons.warning, size: 64),
          title: 'Are you sure?',
          subtitle: 'This action cannot be undone.',
        ),
      );
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('This action cannot be undone.'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('renders primary and secondary buttons', (tester) async {
      await pumpWidget(
        tester,
        PromptDialog(
          image: const Icon(Icons.warning),
          title: 'Confirm',
          subtitle: 'Proceed?',
          primaryButton: ButtonPrimary(onPressed: () {}, child: const Text('Yes')),
          secondaryButton: ButtonSecondary(onPressed: () {}, child: const Text('No')),
        ),
      );
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('renders without buttons', (tester) async {
      await pumpWidget(
        tester,
        const PromptDialog(image: Icon(Icons.info), title: 'Info', subtitle: 'Just so you know.'),
      );
      expect(find.text('Info'), findsOneWidget);
    });

    testWidgets('renders on mobile screenType', (tester) async {
      await pumpWidget(
        tester,
        PromptDialog(
          image: const Icon(Icons.warning),
          title: 'Confirm',
          subtitle: 'Proceed?',
          primaryButton: ButtonPrimary(onPressed: () {}, child: const Text('Yes')),
          secondaryButton: ButtonSecondary(onPressed: () {}, child: const Text('No')),
        ),
      );
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('renders on tablet screenType', (tester) async {
      await pumpWidget(
        tester,
        PromptDialog(
          image: const Icon(Icons.warning),
          title: 'Confirm',
          subtitle: 'Proceed?',
          primaryButton: ButtonPrimary(onPressed: () {}, child: const Text('Yes')),
          secondaryButton: ButtonSecondary(onPressed: () {}, child: const Text('No')),
        ),
        screenType: ScreenType.tablet,
      );
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('desktop buttons keep a fixed 40/60 split even with a long primary label', (
      tester,
    ) async {
      await pumpWidget(
        tester,
        PromptDialog(
          image: const Icon(Icons.warning),
          title: 'Confirm',
          subtitle: 'Proceed?',
          primaryButton: ButtonPrimary(
            onPressed: () {},
            child: const Text('Allow notifications please'),
          ),
          secondaryButton: ButtonSecondary(onPressed: () {}, child: const Text('No')),
        ),
        screenType: ScreenType.tablet,
      );

      final secondaryWidth = tester.getSize(find.byType(ButtonSecondary)).width;
      final primaryWidth = tester.getSize(find.byType(ButtonPrimary)).width;

      // Primary should be ~1.5× the secondary (60/40), NOT dictated by its
      // (long) label. Allow slack for the inter-button spacing.
      expect(primaryWidth / secondaryWidth, closeTo(1.5, 0.15));
    });

    testWidgets('desktop buttons stay equal height when one label wraps to two lines', (
      tester,
    ) async {
      await pumpWidget(
        tester,
        PromptDialog(
          image: const Icon(Icons.warning),
          title: 'Confirm',
          subtitle: 'Proceed?',
          // Long label in the primary forces its text to wrap to 2 lines.
          primaryButton: ButtonPrimary(
            onPressed: () {},
            child: const Text('Allow all notifications from this app'),
          ),
          secondaryButton: ButtonSecondary(onPressed: () {}, child: const Text('No')),
        ),
        screenType: ScreenType.tablet,
      );

      final primaryHeight = tester.getSize(find.byType(ButtonPrimary)).height;
      final secondaryHeight = tester.getSize(find.byType(ButtonSecondary)).height;

      expect(primaryHeight, greaterThan(44), reason: 'the long label should wrap');
      expect(secondaryHeight, primaryHeight, reason: 'short button should match the wrapped one');
    });
  });
}
