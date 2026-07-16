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

    testWidgets('renders in dark theme', (tester) async {
      await pumpWidget(tester, buildCard(unread: true), theme: DesignSystem.darkTheme);

      expect(find.text('Investigating slow connections in Germany'), findsOneWidget);
      expect(_unreadDot(), findsOneWidget);
    });
  });
}
