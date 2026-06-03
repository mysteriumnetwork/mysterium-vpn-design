import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

Color _labelColor(WidgetTester tester) => tester.widget<Text>(find.byType(Text)).style!.color!;

Color _iconColor(WidgetTester tester, IconData icon) =>
    tester.widget<Icon>(find.byIcon(icon)).color!;

Color? _buttonBackgroundColor(WidgetTester tester) {
  final material = tester.widget<Material>(
    find.descendant(of: find.byType(TextButton), matching: find.byType(Material)),
  );
  return material.color;
}

void main() {
  group('FloatingButton', () {
    testWidgets('renders label and icon', (tester) async {
      // act
      await pumpWidget(
        tester,
        const FloatingButton(label: 'Skip', icon: Icons.close, onPressed: null),
      );

      // assert
      expect(find.text('Skip'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      // arrange
      var pressed = false;

      // act
      await pumpWidget(
        tester,
        FloatingButton(label: 'Skip', icon: Icons.close, onPressed: () => pressed = true),
      );
      await tester.tap(find.text('Skip'));

      // assert
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      // arrange
      const pressed = false;

      // act
      await pumpWidget(
        tester,
        const FloatingButton(label: 'Skip', icon: Icons.close, onPressed: null),
      );
      await tester.tap(find.text('Skip'));

      // assert
      expect(pressed, isFalse);
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('light theme uses design-system colors', (tester) async {
      // act
      await pumpWidget(
        tester,
        const FloatingButton(label: 'Skip', icon: Icons.close, onPressed: null),
        theme: DesignSystem.lightTheme,
      );

      // assert
      expect(_buttonBackgroundColor(tester), Palette.grayLight.shade25);
      expect(_labelColor(tester), Palette.grayDark.shade800);
      expect(_iconColor(tester, Icons.close), Palette.grayDark.shade800);
    });

    testWidgets('dark theme uses design-system colors', (tester) async {
      // act
      await pumpWidget(
        tester,
        const FloatingButton(label: 'Skip', icon: Icons.close, onPressed: null),
        theme: DesignSystem.darkTheme,
      );

      // assert
      expect(_buttonBackgroundColor(tester), Palette.grayDark.shade800);
      expect(_labelColor(tester), Palette.white);
      expect(_iconColor(tester, Icons.close), Palette.white);
    });

    testWidgets('icon is rendered at 16 px', (tester) async {
      // act
      await pumpWidget(
        tester,
        const FloatingButton(label: 'Skip', icon: Icons.close, onPressed: null),
      );

      // assert
      expect(tester.widget<Icon>(find.byIcon(Icons.close)).size, 16);
    });
  });
}
