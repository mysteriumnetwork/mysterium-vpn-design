import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _items = <NavRailItem>[
  NavRailItem(icon: UntitledUI.map_01),
  NavRailItem(icon: UntitledUI.star_06),
  NavRailItem(icon: UntitledUI.settings_01),
];

/// Pumps [child] inside an [Align] (loose width) + [SizedBox] (bounded
/// height) so [NavRail] receives the constraints its layout assumes.
Future<void> _pumpRail(WidgetTester tester, Widget child, {double height = 600}) async {
  await pumpWidget(
    tester,
    Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(height: height, child: child),
    ),
  );
}

Color _iconColor(WidgetTester tester, IconData icon) =>
    tester.widget<Icon>(find.byIcon(icon)).color!;

Color? _bgFor(WidgetTester tester, IconData icon) {
  final box = tester
      .widget<DecoratedBox>(
        find.ancestor(of: find.byIcon(icon), matching: find.byType(DecoratedBox)).first,
      )
      .decoration;
  return (box as BoxDecoration).color;
}

EdgeInsetsGeometry _navRailPadding(WidgetTester tester) =>
    tester.widget<NavRail>(find.byType(NavRail)).padding;

void main() {
  group('NavRail', () {
    testWidgets('renders every icon', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 0));

      for (final item in _items) {
        expect(find.byIcon(item.icon), findsOneWidget);
      }
    });

    testWidgets('selected item uses textPrimarySelected icon + bgSecondarySelected bg', (
      tester,
    ) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 1));
      final palette = DesignSystem.lightTheme.palette;

      expect(_iconColor(tester, UntitledUI.star_06), palette.textPrimarySelected);
      expect(_bgFor(tester, UntitledUI.star_06), palette.bgSecondarySelected);
    });

    testWidgets('unselected items use iconTertiary and have no fill', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 1));
      final palette = DesignSystem.lightTheme.palette;

      expect(_iconColor(tester, UntitledUI.map_01), palette.iconTertiary);
      expect(_iconColor(tester, UntitledUI.settings_01), palette.iconTertiary);
      expect(_bgFor(tester, UntitledUI.map_01), isNull);
      expect(_bgFor(tester, UntitledUI.settings_01), isNull);
    });

    testWidgets('calls onTap when an item is tapped', (tester) async {
      var tapped = 0;
      final items = [
        const NavRailItem(icon: UntitledUI.map_01),
        NavRailItem(icon: UntitledUI.star_06, onTap: () => tapped++),
      ];

      await _pumpRail(tester, NavRail(items: items, currentIndex: 0));
      await tester.tap(find.byIcon(UntitledUI.star_06));
      expect(tapped, 1);
    });

    testWidgets('items without onTap are non-interactive but render', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 0));
      await tester.tap(find.byIcon(UntitledUI.map_01));
      expect(find.byIcon(UntitledUI.map_01), findsOneWidget);
    });

    testWidgets('paints bgPrimaryHover on hover over an unselected item', (tester) async {
      await _pumpRail(
        tester,
        NavRail(
          currentIndex: 0,
          items: [
            const NavRailItem(icon: UntitledUI.map_01),
            NavRailItem(icon: UntitledUI.star_06, onTap: () {}),
            NavRailItem(icon: UntitledUI.settings_01, onTap: () {}),
          ],
        ),
      );
      final palette = DesignSystem.lightTheme.palette;

      expect(_bgFor(tester, UntitledUI.star_06), isNull);

      final fad = tester.widget<FocusableActionDetector>(
        find.ancestor(
          of: find.byIcon(UntitledUI.star_06),
          matching: find.byType(FocusableActionDetector),
        ),
      );
      fad.onShowHoverHighlight!(true);
      await tester.pump();

      expect(_bgFor(tester, UntitledUI.star_06), palette.bgPrimaryHover);
    });

    testWidgets('does not paint hover bg on the selected item', (tester) async {
      await _pumpRail(
        tester,
        NavRail(
          currentIndex: 1,
          items: [
            const NavRailItem(icon: UntitledUI.map_01),
            NavRailItem(icon: UntitledUI.star_06, onTap: () {}),
            NavRailItem(icon: UntitledUI.settings_01, onTap: () {}),
          ],
        ),
      );
      final palette = DesignSystem.lightTheme.palette;

      final fad = tester.widget<FocusableActionDetector>(
        find.ancestor(
          of: find.byIcon(UntitledUI.star_06),
          matching: find.byType(FocusableActionDetector),
        ),
      );
      fad.onShowHoverHighlight!(true);
      await tester.pump();

      // Selected fill stays.
      expect(_bgFor(tester, UntitledUI.star_06), palette.bgSecondarySelected);
    });

    testWidgets('paints bgPrimaryHover on focus over an unselected item', (tester) async {
      await _pumpRail(
        tester,
        NavRail(
          currentIndex: 0,
          items: [
            const NavRailItem(icon: UntitledUI.map_01),
            NavRailItem(icon: UntitledUI.star_06, onTap: () {}),
            NavRailItem(icon: UntitledUI.settings_01, onTap: () {}),
          ],
        ),
      );
      final palette = DesignSystem.lightTheme.palette;

      final fad = tester.widget<FocusableActionDetector>(
        find.ancestor(
          of: find.byIcon(UntitledUI.star_06),
          matching: find.byType(FocusableActionDetector),
        ),
      );
      fad.onShowFocusHighlight!(true);
      await tester.pump();

      expect(_bgFor(tester, UntitledUI.star_06), palette.bgPrimaryHover);
    });

    testWidgets('items without onTap have FocusableActionDetector disabled', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 0));

      final fad = tester.widget<FocusableActionDetector>(
        find.ancestor(
          of: find.byIcon(UntitledUI.map_01),
          matching: find.byType(FocusableActionDetector),
        ),
      );
      expect(fad.enabled, isFalse);
    });

    testWidgets('outer rail width is 48 px', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 0));
      expect(tester.getSize(find.byType(NavRail)).width, 48);
    });

    testWidgets('always fills available height', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 0), height: 400);
      expect(tester.getSize(find.byType(NavRail)).height, 400);
    });

    testWidgets('default padding is EdgeInsets.only(top: 86)', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 0));
      expect(_navRailPadding(tester), const EdgeInsets.only(top: 86));
    });

    testWidgets('respects custom padding', (tester) async {
      await _pumpRail(
        tester,
        const NavRail(items: _items, currentIndex: 0, padding: EdgeInsets.symmetric(vertical: 24)),
      );
      expect(_navRailPadding(tester), const EdgeInsets.symmetric(vertical: 24));
    });

    testWidgets('asserts when items count is below 2', (tester) async {
      await _pumpRail(
        tester,
        const NavRail(items: [NavRailItem(icon: UntitledUI.map_01)], currentIndex: 0),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('asserts when currentIndex is out of range', (tester) async {
      await _pumpRail(tester, const NavRail(items: _items, currentIndex: 3));
      expect(tester.takeException(), isAssertionError);
    });
  });
}
