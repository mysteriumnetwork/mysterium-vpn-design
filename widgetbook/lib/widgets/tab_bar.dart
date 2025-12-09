import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'TabBar', type: TabBar)
Widget buildTabBar(BuildContext context) {
  final tabCount = context.knobs.int
      .slider(
        label: 'Number of tabs',
        initialValue: 3,
        description: '(1-10)',
        max: 10,
        min: 1,
      )
      .clamp(1, 10);

  return DefaultTabController(
    length: tabCount,
    child: TabBar(
      tabs: [for (var i = 1; i <= tabCount; i++) Tab(text: 'Tab $i')],
    ),
  );
}
