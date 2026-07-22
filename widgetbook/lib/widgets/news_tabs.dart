import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

List<NewsTabItem> _items({bool disableEmpty = false}) => [
  const NewsTabItem(icon: UntitledUI.inbox_01, label: 'All'),
  const NewsTabItem(icon: UntitledUI.alert_triangle, label: 'Incidents'),
  NewsTabItem(icon: UntitledUI.file_06, label: 'News', enabled: !disableEmpty),
  NewsTabItem(icon: UntitledUI.tag_01, label: 'Offers', enabled: !disableEmpty),
];

@UseCase(name: 'NewsTabs', type: NewsTabs)
Widget buildNewsTabs(BuildContext context) {
  final interactive = context.knobs.boolean(label: 'Interactive', initialValue: true);
  final disableEmpty = context.knobs.boolean(label: 'Disable empty categories');
  return Padding(
    padding: const EdgeInsets.all(16),
    child: _NewsTabsDemo(interactive: interactive, disableEmpty: disableEmpty),
  );
}

class _NewsTabsDemo extends StatefulWidget {
  const _NewsTabsDemo({required this.interactive, required this.disableEmpty});

  final bool interactive;
  final bool disableEmpty;

  @override
  State<_NewsTabsDemo> createState() => _NewsTabsDemoState();
}

class _NewsTabsDemoState extends State<_NewsTabsDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) => NewsTabs(
    items: _items(disableEmpty: widget.disableEmpty),
    selectedIndex: _selected,
    onSelected: widget.interactive ? (i) => setState(() => _selected = i) : null,
  );
}
