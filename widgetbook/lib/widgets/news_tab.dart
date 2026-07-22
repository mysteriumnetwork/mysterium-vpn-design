import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'NewsTab', type: NewsTab)
Widget buildNewsTab(BuildContext context) {
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: NewsTabStatus.values,
    initialOption: NewsTabStatus.idle,
    labelBuilder: (s) => s.name,
  );
  final icon = context.knobs.object.dropdown(
    label: 'Icon',
    options: WidgetbookUtils.newsCategoryIcons.entries.toList(),
    initialOption: WidgetbookUtils.newsCategoryIcons.entries.first,
    labelBuilder: (entry) => entry.key,
  );
  return Padding(
    padding: const EdgeInsets.all(16),
    child: NewsTab(
      icon: icon.value,
      label: context.knobs.string(label: 'Label', initialValue: 'Incidents'),
      status: status,
      onTap: () {},
    ),
  );
}
