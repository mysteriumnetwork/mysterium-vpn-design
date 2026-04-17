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
  });
}
