import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _items = <BottomNavBarItem>[
  BottomNavBarItem(icon: UntitledUI.map_01, label: 'Map'),
  BottomNavBarItem(icon: UntitledUI.flag_01, label: 'Locations'),
  BottomNavBarItem(icon: UntitledUI.star_06, label: 'Products'),
  BottomNavBarItem(icon: UntitledUI.settings_01, label: 'Settings'),
];

Color _iconColor(WidgetTester tester, IconData icon) =>
    tester.widget<Icon>(find.byIcon(icon)).color!;

Color _labelColor(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style!.color!;

/// Finder for the FocusableActionDetector wrapping the given cell.
Finder _cellFad(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(FocusableActionDetector));

/// Returns the BoxDecoration of the DecoratedBox that paints the cell's
/// hover/focus background.
BoxDecoration _cellDecoration(WidgetTester tester, String label) =>
    tester
            .widget<DecoratedBox>(
              find.descendant(of: _cellFad(label), matching: find.byType(DecoratedBox)).first,
            )
            .decoration
        as BoxDecoration;

void main() {
  group('BottomNavBar', () {
    testWidgets('renders every item with its icon and label', (tester) async {
      await pumpWidget(tester, const BottomNavBar(items: _items, selectedIndex: 0));

      for (final item in _items) {
        expect(find.byIcon(item.icon), findsOneWidget);
        expect(find.text(item.label), findsOneWidget);
      }
    });

    testWidgets('does not render any Tooltip widgets', (tester) async {
      await pumpWidget(tester, const BottomNavBar(items: _items, selectedIndex: 0));
      expect(find.byType(Tooltip), findsNothing);
    });

    testWidgets('selected item uses textPrimarySelected for icon and label', (tester) async {
      await pumpWidget(tester, const BottomNavBar(items: _items, selectedIndex: 1));
      final palette = DesignSystem.lightTheme.palette;

      expect(_iconColor(tester, UntitledUI.flag_01), palette.textPrimarySelected);
      expect(_labelColor(tester, 'Locations'), palette.textPrimarySelected);
    });

    testWidgets('unselected items use textTertiary for icon and label', (tester) async {
      await pumpWidget(tester, const BottomNavBar(items: _items, selectedIndex: 1));
      final palette = DesignSystem.lightTheme.palette;

      expect(_iconColor(tester, UntitledUI.map_01), palette.textTertiary);
      expect(_labelColor(tester, 'Map'), palette.textTertiary);
      expect(_iconColor(tester, UntitledUI.star_06), palette.textTertiary);
      expect(_labelColor(tester, 'Products'), palette.textTertiary);
    });

    testWidgets('calls onDestinationSelected when an item is tapped', (tester) async {
      var tapped = -1;
      await pumpWidget(
        tester,
        BottomNavBar(items: _items, selectedIndex: 0, onDestinationSelected: (i) => tapped = i),
      );

      await tester.tap(find.text('Locations'));
      expect(tapped, 1);
    });

    testWidgets('whole cell area is tappable — icon, label, and gap between them', (tester) async {
      final taps = <int>[];
      await pumpWidget(
        tester,
        BottomNavBar(items: _items, selectedIndex: 0, onDestinationSelected: taps.add),
      );

      // Verify every region of the cell registers a tap, not just the icon.
      final iconCenter = tester.getCenter(find.byIcon(UntitledUI.star_06));
      final labelCenter = tester.getCenter(find.text('Products'));
      final betweenIconAndLabel = Offset(iconCenter.dx, (iconCenter.dy + labelCenter.dy) / 2);

      final cellRect = tester.getRect(
        find.ancestor(of: find.byIcon(UntitledUI.star_06), matching: find.byType(Expanded)).first,
      );
      final cellCorner = cellRect.topLeft + const Offset(2, 2);

      await tester.tapAt(iconCenter);
      await tester.tapAt(labelCenter);
      await tester.tapAt(betweenIconAndLabel);
      await tester.tapAt(cellCorner);

      expect(taps, [2, 2, 2, 2]);
    });

    testWidgets('is non-interactive when onDestinationSelected is null', (tester) async {
      await pumpWidget(tester, const BottomNavBar(items: _items, selectedIndex: 0));
      // Tapping should not throw.
      await tester.tap(find.text('Map'));
      expect(find.text('Map'), findsOneWidget);
    });

    testWidgets('paints bgSidePanelHover on hover over an unselected cell', (tester) async {
      await pumpWidget(
        tester,
        BottomNavBar(items: _items, selectedIndex: 0, onDestinationSelected: (_) {}),
      );
      final palette = DesignSystem.lightTheme.palette;

      expect(_cellDecoration(tester, 'Locations').color, isNull);

      tester.widget<FocusableActionDetector>(_cellFad('Locations')).onShowHoverHighlight!(true);
      await tester.pump();

      expect(_cellDecoration(tester, 'Locations').color, palette.bgSidePanelHover);
    });

    testWidgets('does not paint hover bg on the selected cell', (tester) async {
      await pumpWidget(
        tester,
        BottomNavBar(items: _items, selectedIndex: 1, onDestinationSelected: (_) {}),
      );

      tester.widget<FocusableActionDetector>(_cellFad('Locations')).onShowHoverHighlight!(true);
      await tester.pump();

      // Selected cells have no fill regardless of hover.
      expect(_cellDecoration(tester, 'Locations').color, isNull);
    });

    testWidgets('paints bgSidePanelHover on focus over an unselected cell', (tester) async {
      await pumpWidget(
        tester,
        BottomNavBar(items: _items, selectedIndex: 0, onDestinationSelected: (_) {}),
      );
      final palette = DesignSystem.lightTheme.palette;

      tester.widget<FocusableActionDetector>(_cellFad('Locations')).onShowFocusHighlight!(true);
      await tester.pump();

      expect(_cellDecoration(tester, 'Locations').color, palette.bgSidePanelHover);
    });

    testWidgets('non-interactive cells do not show hover/focus bg', (tester) async {
      await pumpWidget(tester, const BottomNavBar(items: _items, selectedIndex: 0));

      // FocusableActionDetector.enabled is false → onShowHoverHighlight is null
      // and the cell won't react.
      final fad = tester.widget<FocusableActionDetector>(_cellFad('Locations'));
      expect(fad.enabled, isFalse);
    });

    testWidgets('exposes per-cell button semantics with selected state', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpWidget(
        tester,
        BottomNavBar(items: _items, selectedIndex: 2, onDestinationSelected: (_) {}),
      );

      // Locations cell: not selected, button.
      expect(
        tester.getSemantics(find.text('Locations')),
        matchesSemantics(
          label: 'Locations',
          isButton: true,
          hasSelectedState: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      // Products cell: selected.
      expect(
        tester.getSemantics(find.text('Products')),
        matchesSemantics(
          label: 'Products',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );

      handle.dispose();
    });

    testWidgets('itemWrapper wraps each tab cell', (tester) async {
      // act
      await pumpWidget(
        tester,
        BottomNavBar(
          items: _items,
          selectedIndex: 0,
          itemWrapper: ({required context, required index, required item, required child}) =>
              KeyedSubtree(key: Key('wrapped-$index'), child: child),
        ),
      );

      // assert
      expect(find.byKey(const Key('wrapped-0')), findsOneWidget);
      expect(find.byKey(const Key('wrapped-1')), findsOneWidget);
      expect(find.byKey(const Key('wrapped-2')), findsOneWidget);
      expect(find.byKey(const Key('wrapped-3')), findsOneWidget);
    });

    testWidgets('itemWrapper receives correct index and item metadata', (tester) async {
      // arrange
      final seenIndices = <int>[];
      final seenLabels = <String>[];

      // act
      await pumpWidget(
        tester,
        BottomNavBar(
          items: _items,
          selectedIndex: 0,
          itemWrapper: ({required context, required index, required item, required child}) {
            seenIndices.add(index);
            seenLabels.add(item.label);
            return child;
          },
        ),
      );

      // assert
      expect(seenIndices, <int>[0, 1, 2, 3]);
      expect(seenLabels, <String>['Map', 'Locations', 'Products', 'Settings']);
    });

    testWidgets('itemWrapper can wrap only selected items', (tester) async {
      await pumpWidget(
        tester,
        BottomNavBar(
          items: _items,
          selectedIndex: 0,
          itemWrapper: ({required context, required index, required item, required child}) {
            if (index == 1) {
              return KeyedSubtree(key: const Key('only-locations-wrapped'), child: child);
            }
            return child;
          },
        ),
      );

      expect(find.byKey(const Key('only-locations-wrapped')), findsOneWidget);
    });

    testWidgets('hover-leave while focused keeps the highlight', (tester) async {
      await pumpWidget(
        tester,
        BottomNavBar(items: _items, selectedIndex: 0, onDestinationSelected: (_) {}),
      );
      final palette = DesignSystem.lightTheme.palette;
      final fad = tester.widget<FocusableActionDetector>(_cellFad('Locations'));

      fad.onShowFocusHighlight!(true);
      fad.onShowHoverHighlight!(true);
      await tester.pump();
      expect(_cellDecoration(tester, 'Locations').color, palette.bgSidePanelHover);

      // Mouse leaves but focus is still on the cell — highlight must stay.
      fad.onShowHoverHighlight!(false);
      await tester.pump();
      expect(_cellDecoration(tester, 'Locations').color, palette.bgSidePanelHover);

      // Focus also leaves — highlight clears.
      fad.onShowFocusHighlight!(false);
      await tester.pump();
      expect(_cellDecoration(tester, 'Locations').color, isNull);
    });

    testWidgets('asserts when items count is below 2', (tester) async {
      await pumpWidget(
        tester,
        const BottomNavBar(
          items: [BottomNavBarItem(icon: UntitledUI.map_01, label: 'Map')],
          selectedIndex: 0,
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('asserts when selectedIndex is out of range', (tester) async {
      await pumpWidget(tester, const BottomNavBar(items: _items, selectedIndex: 4));
      expect(tester.takeException(), isAssertionError);
    });
  });
}
