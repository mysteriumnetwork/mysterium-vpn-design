import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'NewsPill', type: NewsPill)
Widget buildNewsPill(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Incidents');
  final icon = context.knobs.object.dropdown(
    label: 'Icon',
    options: WidgetbookUtils.newsCategoryIcons.entries.toList(),
    initialOption: WidgetbookUtils.newsCategoryIcons.entries.first,
    labelBuilder: (entry) => entry.key,
  );
  return Padding(
    padding: const EdgeInsets.all(16),
    child: NewsPill(icon: icon.value, label: label),
  );
}

@UseCase(name: 'Variants', type: NewsPill)
Widget buildNewsPillVariants(BuildContext context) => const Padding(
  padding: EdgeInsets.all(16),
  child: Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      NewsPill(icon: UntitledUI.alert_triangle, label: 'Incidents'),
      NewsPill(icon: UntitledUI.file_06, label: 'News'),
      NewsPill(icon: UntitledUI.tag_01, label: 'Offers'),
    ],
  ),
);
