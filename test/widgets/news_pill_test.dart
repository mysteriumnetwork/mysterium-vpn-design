import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

BoxDecoration _pillDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.ancestor(of: find.byType(Row), matching: find.byType(Container)),
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  group('NewsPill', () {
    testWidgets('renders the label uppercased', (tester) async {
      await pumpWidget(tester, const NewsPill(icon: UntitledUI.file_06, label: 'News'));

      expect(find.text('NEWS'), findsOneWidget);
      expect(find.text('News'), findsNothing);
    });

    testWidgets('renders the provided icon', (tester) async {
      await pumpWidget(tester, const NewsPill(icon: UntitledUI.alert_triangle, label: 'Incidents'));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, UntitledUI.alert_triangle);
      expect(icon.size, 12);
    });

    testWidgets('uses the bgNewsPill background token', (tester) async {
      await pumpWidget(tester, const NewsPill(icon: UntitledUI.tag_01, label: 'Offers'));

      expect(_pillDecoration(tester).color, const PaletteLight().bgNewsPill);
    });

    testWidgets('honours the background override', (tester) async {
      await pumpWidget(
        tester,
        const NewsPill(icon: UntitledUI.file_06, label: 'News', background: Color(0xFF123456)),
      );

      expect(_pillDecoration(tester).color, const Color(0xFF123456));
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await pumpWidget(
        tester,
        const NewsPill(icon: UntitledUI.tag_01, label: 'Offers'),
        theme: DesignSystem.darkTheme,
      );

      expect(find.text('OFFERS'), findsOneWidget);
    });
  });
}
