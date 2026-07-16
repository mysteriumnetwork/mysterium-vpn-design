import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('NewsPill', () {
    testWidgets('renders the label uppercased with its icon', (tester) async {
      await pumpWidget(tester, const NewsPill(icon: UntitledUI.alert_triangle, label: 'Incidents'));

      expect(find.text('INCIDENTS'), findsOneWidget);
      expect(find.byIcon(UntitledUI.alert_triangle), findsOneWidget);
    });

    testWidgets('renders each category variant without error', (tester) async {
      const categories = {
        'Incidents': UntitledUI.alert_triangle,
        'News': UntitledUI.file_06,
        'Offers': UntitledUI.tag_01,
      };

      for (final entry in categories.entries) {
        await pumpWidget(tester, NewsPill(icon: entry.value, label: entry.key));
        expect(find.text(entry.key.toUpperCase()), findsOneWidget);
        expect(find.byIcon(entry.value), findsOneWidget);
      }
    });

    testWidgets('applies the background override', (tester) async {
      await pumpWidget(
        tester,
        const NewsPill(icon: UntitledUI.tag_01, label: 'Offers', background: Palette.white),
      );

      final container = tester.widget<Container>(
        find.descendant(of: find.byType(NewsPill), matching: find.byType(Container)),
      );
      expect((container.decoration! as BoxDecoration).color, Palette.white);
    });

    testWidgets('renders in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const NewsPill(icon: UntitledUI.file_06, label: 'News'),
        theme: DesignSystem.darkTheme,
      );

      expect(find.text('NEWS'), findsOneWidget);
    });
  });
}
