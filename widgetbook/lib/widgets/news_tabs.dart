import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

const _items = [
  NewsTabItem(icon: UntitledUI.inbox_01, label: 'All'),
  NewsTabItem(icon: UntitledUI.alert_triangle, label: 'Incidents'),
  NewsTabItem(icon: UntitledUI.file_06, label: 'News'),
  NewsTabItem(icon: UntitledUI.tag_01, label: 'Offers'),
];

@UseCase(name: 'NewsTabs', type: NewsTabs)
Widget buildNewsTabs(BuildContext context) {
  final interactive = context.knobs.boolean(label: 'Interactive', initialValue: true);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: _NewsTabsDemo(interactive: interactive),
  );
}

class _NewsTabsDemo extends StatefulWidget {
  const _NewsTabsDemo({required this.interactive});

  final bool interactive;

  @override
  State<_NewsTabsDemo> createState() => _NewsTabsDemoState();
}

class _NewsTabsDemoState extends State<_NewsTabsDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) => NewsTabs(
    items: _items,
    selectedIndex: _selected,
    onSelected: widget.interactive ? (i) => setState(() => _selected = i) : null,
  );
}
