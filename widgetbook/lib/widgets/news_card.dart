import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'News Card', type: NewsCard)
Widget buildNewsCard(BuildContext context) {
  final category = context.knobs.object.dropdown(
    label: 'Category',
    initialOption: WidgetbookUtils.newsCategoryIcons.keys.first,
    options: WidgetbookUtils.newsCategoryIcons.keys.toList(),
    labelBuilder: (value) => value,
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Investigating slow connections in Germany',
  );
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'Some residential IPs in Frankfurt are reconnecting more slowly than usual.',
  );
  final timeLabel = context.knobs.string(label: 'Time', initialValue: '12min ago');
  final unread = context.knobs.boolean(label: 'Unread', initialValue: true);
  final interactive = context.knobs.boolean(label: 'Interactive (onTap)', initialValue: true);

  return Center(
    child: SizedBox(
      width: 360,
      child: NewsCard(
        categoryIcon: WidgetbookUtils.newsCategoryIcons[category]!,
        categoryLabel: category,
        title: title,
        message: message,
        timeLabel: timeLabel,
        unread: unread,
        onTap: interactive ? () {} : null,
      ),
    ),
  );
}
