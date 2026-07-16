import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'News Pill', type: NewsPill)
Widget buildNewsPill(BuildContext context) {
  final category = context.knobs.object.dropdown(
    label: 'Category',
    initialOption: WidgetbookUtils.newsCategoryIcons.keys.first,
    options: WidgetbookUtils.newsCategoryIcons.keys.toList(),
    labelBuilder: (value) => value,
  );

  return Center(
    child: NewsPill(icon: WidgetbookUtils.newsCategoryIcons[category]!, label: category),
  );
}
