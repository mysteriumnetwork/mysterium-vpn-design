import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('OnboardingItem', () {
    testWidgets('renders without any slots', (tester) async {
      await pumpWidget(tester, const OnboardingItem());
      expect(find.byType(OnboardingItem), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders label when provided', (tester) async {
      await pumpWidget(tester, const OnboardingItem(label: 'Connection'));
      expect(find.text('Connection'), findsOneWidget);
    });

    testWidgets('renders value when provided', (tester) async {
      await pumpWidget(tester, const OnboardingItem(value: '84.122.47.219'));
      expect(find.text('84.122.47.219'), findsOneWidget);
    });

    testWidgets('renders leading widget when provided', (tester) async {
      await pumpWidget(
        tester,
        const OnboardingItem(leading: Icon(Icons.public, key: Key('leading-icon'))),
      );
      expect(find.byKey(const Key('leading-icon')), findsOneWidget);
    });

    testWidgets('renders trailing widget when provided', (tester) async {
      await pumpWidget(
        tester,
        const OnboardingItem(trailing: Icon(Icons.check, key: Key('trailing-icon'))),
      );
      expect(find.byKey(const Key('trailing-icon')), findsOneWidget);
    });

    testWidgets('renders all four slots together', (tester) async {
      await pumpWidget(
        tester,
        const OnboardingItem(
          leading: Icon(Icons.public, key: Key('leading')),
          label: 'IP address',
          value: '84.122.47.219',
          trailing: Icon(Icons.visibility, key: Key('trailing')),
        ),
      );
      expect(find.byKey(const Key('leading')), findsOneWidget);
      expect(find.text('IP address'), findsOneWidget);
      expect(find.text('84.122.47.219'), findsOneWidget);
      expect(find.byKey(const Key('trailing')), findsOneWidget);
    });

    testWidgets('right-side slots hug the right edge of the card', (tester) async {
      const trailingKey = Key('trailing');
      await pumpWidget(
        tester,
        const Center(
          child: SizedBox(
            width: 343,
            child: OnboardingItem(
              label: 'IP',
              value: '1.2.3.4',
              trailing: SizedBox(width: 20, height: 20, key: trailingKey),
            ),
          ),
        ),
      );

      final card = tester.getRect(find.byType(OnboardingItem));
      final trailing = tester.getRect(find.byKey(trailingKey));
      final value = tester.getRect(find.text('1.2.3.4'));

      // Trailing sits to the right of the value text.
      expect(trailing.left, greaterThan(value.right));
      // Trailing sits flush against the card's right padding (15px from edge).
      expect(card.right - trailing.right, closeTo(15, 1));
    });

    testWidgets('right-side slots stay at the right edge with a long label', (tester) async {
      const trailingKey = Key('trailing');
      await pumpWidget(
        tester,
        const Center(
          child: SizedBox(
            width: 343,
            child: OnboardingItem(
              label:
                  'A very very very very very long label that should ellipsize before pushing the value',
              value: '1.2.3.4',
              trailing: SizedBox(width: 20, height: 20, key: trailingKey),
            ),
          ),
        ),
      );

      final card = tester.getRect(find.byType(OnboardingItem));
      final trailing = tester.getRect(find.byKey(trailingKey));
      expect(card.right - trailing.right, closeTo(15, 1));
    });

    testWidgets('right-side trailing alone is right-aligned', (tester) async {
      const trailingKey = Key('trailing');
      await pumpWidget(
        tester,
        const Center(
          child: SizedBox(
            width: 343,
            child: OnboardingItem(
              label: 'Connection',
              trailing: SizedBox(width: 100, height: 20, key: trailingKey),
            ),
          ),
        ),
      );

      final card = tester.getRect(find.byType(OnboardingItem));
      final trailing = tester.getRect(find.byKey(trailingKey));
      expect(card.right - trailing.right, closeTo(15, 1));
    });

    testWidgets('applies custom borderColor', (tester) async {
      const accent = Color(0xFFFF0000);
      await pumpWidget(tester, const OnboardingItem(label: 'Tap', borderColor: accent));
      final box = tester.firstWidget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.border, isA<Border>());
      final border = decoration.border! as Border;
      expect(border.top.color, accent);
    });

    testWidgets('uses palette.bgInfoCard in light theme', (tester) async {
      await pumpWidget(
        tester,
        const OnboardingItem(label: 'Connection'),
        theme: DesignSystem.lightTheme,
      );
      final box = tester.firstWidget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.color, const PaletteLight().bgInfoCard);
    });

    testWidgets('uses palette.bgInfoCard in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const OnboardingItem(label: 'Connection'),
        theme: DesignSystem.darkTheme,
      );
      final box = tester.firstWidget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.color, const PaletteDark().bgInfoCard);
    });

    testWidgets('default border uses palette.borderInfoCard', (tester) async {
      await pumpWidget(
        tester,
        const OnboardingItem(label: 'Connection'),
        theme: DesignSystem.lightTheme,
      );
      final box = tester.firstWidget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.top.color, const PaletteLight().borderInfoCard);
    });

    testWidgets('long value ellipsizes instead of overflowing', (tester) async {
      await pumpWidget(
        tester,
        const Center(
          child: SizedBox(
            width: 343,
            child: OnboardingItem(
              leading: SizedBox(width: 28, height: 28),
              label: 'ISP',
              value: 'A really really really really long internet service provider name',
              trailing: SizedBox(width: 20, height: 20),
            ),
          ),
        ),
      );
      // Pump completes without RenderFlex overflow exceptions.
      expect(tester.takeException(), isNull);
    });
  });
}
