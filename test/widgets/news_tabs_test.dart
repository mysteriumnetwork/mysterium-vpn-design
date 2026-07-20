import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _items = [
  NewsTabItem(icon: UntitledUI.inbox_01, label: 'All'),
  NewsTabItem(icon: UntitledUI.alert_triangle, label: 'Incidents'),
  NewsTabItem(icon: UntitledUI.file_06, label: 'News'),
  NewsTabItem(icon: UntitledUI.tag_01, label: 'Offers'),
];

void main() {
  group('NewsTabs', () {
    testWidgets('renders one NewsTab per item', (tester) async {
      await pumpWidget(tester, const NewsTabs(items: _items, selectedIndex: 0));

      expect(find.byType(NewsTab), findsNWidgets(_items.length));
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Offers'), findsOneWidget);
    });

    testWidgets('marks only the selected index as selected', (tester) async {
      await pumpWidget(tester, const NewsTabs(items: _items, selectedIndex: 2));

      final tabs = tester.widgetList<NewsTab>(find.byType(NewsTab)).toList();
      expect(tabs[2].status, NewsTabStatus.selected);
      expect(tabs[0].status, NewsTabStatus.idle);
      expect(tabs[1].status, NewsTabStatus.idle);
      expect(tabs[3].status, NewsTabStatus.idle);
    });

    testWidgets('reports the tapped index via onSelected', (tester) async {
      int? selected;
      await pumpWidget(
        tester,
        NewsTabs(items: _items, selectedIndex: 0, onSelected: (i) => selected = i),
      );

      await tester.tap(find.text('News'));
      expect(selected, 2);
    });

    testWidgets('is non-interactive when onSelected is null', (tester) async {
      await pumpWidget(tester, const NewsTabs(items: _items, selectedIndex: 0));

      final tabs = tester.widgetList<NewsTab>(find.byType(NewsTab));
      expect(tabs.every((t) => t.onTap == null), isTrue);
    });

    testWidgets('renders every tab disabled and ignores taps when disabled', (tester) async {
      int? selected;
      await pumpWidget(
        tester,
        NewsTabs(items: _items, selectedIndex: 1, enabled: false, onSelected: (i) => selected = i),
      );

      final tabs = tester.widgetList<NewsTab>(find.byType(NewsTab)).toList();
      expect(tabs.every((t) => t.status == NewsTabStatus.disabled), isTrue);
      expect(tabs.every((t) => t.onTap == null), isTrue);

      await tester.tap(find.text('News'));
      expect(selected, isNull);
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await pumpWidget(
        tester,
        const NewsTabs(items: _items, selectedIndex: 1),
        theme: DesignSystem.darkTheme,
      );

      expect(find.text('Incidents'), findsOneWidget);
    });
  });
}
