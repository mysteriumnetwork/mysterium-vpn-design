import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

BoxDecoration _tabDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.ancestor(of: find.byType(Row), matching: find.byType(Container)),
  );
  return container.decoration! as BoxDecoration;
}

Color _labelColor(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style!.color!;

void main() {
  group('NewsTab', () {
    testWidgets('renders icon and label', (tester) async {
      await pumpWidget(tester, const NewsTab(icon: UntitledUI.alert_triangle, label: 'Incidents'));

      expect(find.text('Incidents'), findsOneWidget);
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, UntitledUI.alert_triangle);
      expect(icon.size, 16);
    });

    testWidgets('idle uses primary colours', (tester) async {
      await pumpWidget(tester, NewsTab(icon: UntitledUI.file_06, label: 'News', onTap: () {}));

      expect(_tabDecoration(tester).color, const PaletteLight().bgPrimary);
      expect(_labelColor(tester, 'News'), const PaletteLight().textPrimary);
    });

    testWidgets('selected uses the brand selected tokens', (tester) async {
      await pumpWidget(
        tester,
        NewsTab(
          icon: UntitledUI.file_06,
          label: 'News',
          status: NewsTabStatus.selected,
          onTap: () {},
        ),
      );

      expect(_tabDecoration(tester).color, const PaletteLight().bgSecondarySelected);
      expect(_labelColor(tester, 'News'), const PaletteLight().textPrimarySelected);
    });

    testWidgets('disabled uses disabled tokens and ignores taps', (tester) async {
      var tapped = 0;
      await pumpWidget(
        tester,
        NewsTab(
          icon: UntitledUI.file_06,
          label: 'News',
          status: NewsTabStatus.disabled,
          onTap: () => tapped++,
        ),
      );

      expect(_tabDecoration(tester).color, const PaletteLight().bgDisabled);
      expect(_labelColor(tester, 'News'), const PaletteLight().iconDisabled);

      await tester.tap(find.byType(NewsTab));
      expect(tapped, 0);
    });

    testWidgets('calls onTap when interactive', (tester) async {
      var tapped = 0;
      await pumpWidget(
        tester,
        NewsTab(icon: UntitledUI.file_06, label: 'News', onTap: () => tapped++),
      );

      await tester.tap(find.byType(NewsTab));
      expect(tapped, 1);
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await pumpWidget(
        tester,
        const NewsTab(icon: UntitledUI.tag_01, label: 'Offers', status: NewsTabStatus.selected),
        theme: DesignSystem.darkTheme,
      );

      expect(find.text('Offers'), findsOneWidget);
    });
  });
}
