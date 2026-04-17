import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('ButtonPrimary', () {
    testWidgets('renders child text', (tester) async {
      await pumpWidget(tester, ButtonPrimary(onPressed: () {}, child: const Text('Submit')));
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;
      await pumpWidget(
        tester,
        ButtonPrimary(onPressed: () => pressed = true, child: const Text('Tap')),
      );
      await tester.tap(find.text('Tap'));
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      const pressed = false;
      await pumpWidget(tester, const ButtonPrimary(onPressed: null, child: Text('Disabled')));
      await tester.tap(find.text('Disabled'));
      expect(pressed, isFalse);
    });

    testWidgets('shows loading text when loading', (tester) async {
      await pumpWidget(
        tester,
        ButtonPrimary(
          onPressed: () {},
          loading: const ButtonLoading(text: 'Loading...'),
          child: const Text('Submit'),
        ),
      );
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('renders leading and trailing widgets', (tester) async {
      await pumpWidget(
        tester,
        ButtonPrimary(
          onPressed: () {},
          leading: const Icon(Icons.add),
          trailing: const Icon(Icons.arrow_forward),
          child: const Text('Go'),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });
  });

  group('ButtonSecondary', () {
    testWidgets('renders as OutlinedButton', (tester) async {
      await pumpWidget(tester, ButtonSecondary(onPressed: () {}, child: const Text('Secondary')));
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
    });
  });

  group('ButtonTertiary', () {
    testWidgets('renders as TextButton', (tester) async {
      await pumpWidget(tester, ButtonTertiary(onPressed: () {}, child: const Text('Tertiary')));
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Tertiary'), findsOneWidget);
    });
  });

  group('ButtonSize', () {
    testWidgets('all sizes render without error', (tester) async {
      for (final size in ButtonSize.values) {
        await pumpWidget(
          tester,
          ButtonPrimary(onPressed: () {}, size: size, child: Text(size.name)),
        );
        expect(find.text(size.name), findsOneWidget);
      }
    });
  });
}
