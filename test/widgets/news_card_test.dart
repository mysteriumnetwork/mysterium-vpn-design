import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

/// Matches the news-center unread indicator dot by its fill colour.
Finder _unreadDot() => find.byWidgetPredicate(
  (widget) =>
      widget is Container &&
      widget.decoration is BoxDecoration &&
      (widget.decoration! as BoxDecoration).color == Palette.unreadIndicator,
);

/// The card's own surface colour — the only decorated box in the card that
/// carries a border.
Color _surfaceColor(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(of: find.byType(NewsCard), matching: find.byType(DecoratedBox)),
    )
    .map((box) => box.decoration)
    .whereType<BoxDecoration>()
    .firstWhere((decoration) => decoration.border != null)
    .color!;

/// Moves a synthetic mouse pointer onto [finder] to trigger hover.
Future<void> _hover(WidgetTester tester, Finder finder) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(finder));
  await tester.pump();
}

void main() {
  group('NewsCard', () {
    Widget buildCard({bool unread = false, VoidCallback? onTap}) => NewsCard(
      categoryIcon: UntitledUI.alert_triangle,
      categoryLabel: 'Incidents',
      title: 'Investigating slow connections in Germany',
      message: 'Some residential IPs in Frankfurt are reconnecting more slowly than usual.',
      timeLabel: '12min ago',
      unread: unread,
      onTap: onTap,
    );

    testWidgets('renders pill, timestamp, title and message', (tester) async {
      await pumpWidget(tester, buildCard());

      expect(find.byType(NewsPill), findsOneWidget);
      expect(find.text('INCIDENTS'), findsOneWidget);
      expect(find.text('12min ago'), findsOneWidget);
      expect(find.text('Investigating slow connections in Germany'), findsOneWidget);
      expect(
        find.text('Some residential IPs in Frankfurt are reconnecting more slowly than usual.'),
        findsOneWidget,
      );
    });

    testWidgets('shows the unread indicator only when unread', (tester) async {
      await pumpWidget(tester, buildCard());
      expect(_unreadDot(), findsNothing);

      await pumpWidget(tester, buildCard(unread: true));
      expect(_unreadDot(), findsOneWidget);
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var taps = 0;
      await pumpWidget(tester, buildCard(onTap: () => taps++));

      await tester.tap(find.byType(NewsCard));
      expect(taps, 1);
    });

    testWidgets('does not paint the hover background when non-interactive', (tester) async {
      await pumpWidget(tester, buildCard());
      await _hover(tester, find.byType(NewsCard));

      expect(_surfaceColor(tester), const PaletteLight().bgPrimary);
    });

    testWidgets('paints the hover background when interactive', (tester) async {
      await pumpWidget(tester, buildCard(onTap: () {}));
      await _hover(tester, find.byType(NewsCard));

      expect(_surfaceColor(tester), const PaletteLight().bgPrimaryHover);
    });

    testWidgets('uses the click cursor only when interactive', (tester) async {
      Iterable<MouseCursor> cursors() => tester
          .widgetList<MouseRegion>(
            find.descendant(of: find.byType(NewsCard), matching: find.byType(MouseRegion)),
          )
          .map((region) => region.cursor);

      await pumpWidget(tester, buildCard(onTap: () {}));
      expect(cursors(), contains(SystemMouseCursors.click));

      await pumpWidget(tester, buildCard());
      expect(cursors(), isNot(contains(SystemMouseCursors.click)));
    });

    testWidgets('renders in dark theme', (tester) async {
      await pumpWidget(tester, buildCard(unread: true), theme: DesignSystem.darkTheme);

      expect(find.text('Investigating slow connections in Germany'), findsOneWidget);
      expect(_unreadDot(), findsOneWidget);
    });
  });
}
