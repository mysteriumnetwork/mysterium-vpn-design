import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/decoration.dart';
import '../helpers/hover.dart';
import '../helpers/pump_widget.dart';

/// Background of the box NavItem paints its hover/selected fill into.
Color? _bgColor(WidgetTester tester) => decorationOf(tester, find.byType(NavItem)).color;

void main() {
  group('NavItem', () {
    testWidgets('renders icon and label', (tester) async {
      await pumpWidget(tester, const NavItem(icon: Icon(Icons.settings), label: 'Settings'));
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        NavItem(icon: const Icon(Icons.home), label: 'Home', onTap: () => tapped = true),
      );
      await tester.tap(find.text('Home'));
      expect(tapped, isTrue);
    });

    testWidgets('renders trailing widget', (tester) async {
      await pumpWidget(
        tester,
        const NavItem(icon: Icon(Icons.link), label: 'External', trailing: Icon(Icons.open_in_new)),
      );
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('current=true renders without error', (tester) async {
      await pumpWidget(
        tester,
        NavItem(icon: const Icon(Icons.home), label: 'Home', current: true, onTap: () {}),
      );
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('no onTap means not interactive', (tester) async {
      await pumpWidget(tester, const NavItem(icon: Icon(Icons.home), label: 'Home'));
      // Tapping should not throw
      await tester.tap(find.text('Home'));
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('unselected item lifts to bgSidePanelHover on hover', (tester) async {
      await pumpWidget(tester, NavItem(icon: const Icon(Icons.home), label: 'Home', onTap: () {}));
      final palette = DesignSystem.lightTheme.palette;

      expect(_bgColor(tester), Palette.transparent);

      await hover(tester, find.text('Home'));

      expect(_bgColor(tester), palette.bgSidePanelHover);
    });

    testWidgets('selected item lifts to bgSecondarySelectedHover on hover', (tester) async {
      await pumpWidget(
        tester,
        NavItem(icon: const Icon(Icons.home), label: 'Home', current: true, onTap: () {}),
      );
      final palette = DesignSystem.lightTheme.palette;

      expect(_bgColor(tester), palette.bgSecondarySelected);

      await hover(tester, find.text('Home'));

      expect(_bgColor(tester), palette.bgSecondarySelectedHover);
    });

    testWidgets('unselected item uses the dark bgSidePanelHover token', (tester) async {
      await pumpWidget(
        tester,
        NavItem(icon: const Icon(Icons.home), label: 'Home', onTap: () {}),
        theme: DesignSystem.darkTheme,
      );

      await hover(tester, find.text('Home'));

      expect(_bgColor(tester), DesignSystem.darkTheme.palette.bgSidePanelHover);
    });

    testWidgets('selected item uses the dark bgSecondarySelectedHover token', (tester) async {
      await pumpWidget(
        tester,
        NavItem(icon: const Icon(Icons.home), label: 'Home', current: true, onTap: () {}),
        theme: DesignSystem.darkTheme,
      );

      await hover(tester, find.text('Home'));

      expect(_bgColor(tester), DesignSystem.darkTheme.palette.bgSecondarySelectedHover);
    });

    testWidgets('non-interactive item stays transparent on hover', (tester) async {
      await pumpWidget(tester, const NavItem(icon: Icon(Icons.home), label: 'Home'));

      await hover(tester, find.text('Home'));

      expect(_bgColor(tester), Palette.transparent);
    });
  });
}
