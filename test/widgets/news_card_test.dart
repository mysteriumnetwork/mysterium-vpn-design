import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

Widget _card({bool unread = false, VoidCallback? onTap}) => NewsCard(
  categoryIcon: UntitledUI.file_06,
  categoryLabel: 'News',
  title: 'New residential IPs available',
  message: 'We expanded our residential pool with thousands of new IPs.',
  timeLabel: '1d ago',
  unread: unread,
  onTap: onTap,
);

/// The unread-indicator dots currently in the tree.
Iterable<Container> _dots(WidgetTester tester) =>
    tester.widgetList<Container>(find.byType(Container)).where((c) {
      final decoration = c.decoration;
      return decoration is BoxDecoration &&
          decoration.shape == BoxShape.circle &&
          decoration.color == Palette.unreadIndicator;
    });

void main() {
  group('NewsCard', () {
    testWidgets('renders pill label, title, message and time', (tester) async {
      await pumpWidget(tester, _card());

      expect(find.text('NEWS'), findsOneWidget); // pill uppercases
      expect(find.text('New residential IPs available'), findsOneWidget);
      expect(
        find.text('We expanded our residential pool with thousands of new IPs.'),
        findsOneWidget,
      );
      expect(find.text('1d ago'), findsOneWidget);
    });

    testWidgets('pill uses the bgSidePanel background inside the card', (tester) async {
      await pumpWidget(tester, _card());

      final pill = tester.widget<NewsPill>(find.byType(NewsPill));
      expect(pill.background, const PaletteLight().bgSidePanel);
    });

    testWidgets('unread shows the indicator dot and a semibold title', (tester) async {
      await pumpWidget(tester, _card(unread: true));

      expect(_dots(tester), isNotEmpty);

      final title = tester.widget<Text>(find.text('New residential IPs available'));
      expect(title.style!.fontWeight, FontWeight.w600);
    });

    testWidgets('read state has no dot and a medium title', (tester) async {
      await pumpWidget(tester, _card());

      expect(_dots(tester), isEmpty);

      final title = tester.widget<Text>(find.text('New residential IPs available'));
      expect(title.style!.fontWeight, FontWeight.w500);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = 0;
      await pumpWidget(tester, _card(onTap: () => tapped++));

      await tester.tap(find.byType(NewsCard));
      expect(tapped, 1);
    });

    testWidgets('shows the click cursor only when interactive', (tester) async {
      MouseCursor cursorOf(WidgetTester t) => t
          .widget<MouseRegion>(
            find.ancestor(of: find.byType(NewsPill), matching: find.byType(MouseRegion)).first,
          )
          .cursor;

      await pumpWidget(tester, _card(onTap: () {}));
      expect(cursorOf(tester), SystemMouseCursors.click);

      await pumpWidget(tester, _card()); // onTap == null → inert
      expect(cursorOf(tester), MouseCursor.defer);
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await pumpWidget(tester, _card(unread: true), theme: DesignSystem.darkTheme);
      expect(find.text('NEWS'), findsOneWidget);
    });
  });
}
