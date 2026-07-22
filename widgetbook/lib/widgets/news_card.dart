import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'NewsCard', type: NewsCard)
Widget buildNewsCard(BuildContext context) {
  final icon = context.knobs.object.dropdown(
    label: 'Category icon',
    options: WidgetbookUtils.newsCategoryIcons.entries.toList(),
    initialOption: WidgetbookUtils.newsCategoryIcons.entries.first,
    labelBuilder: (entry) => entry.key,
  );
  final unread = context.knobs.boolean(label: 'Unread', initialValue: true);
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 343,
        child: NewsCard(
          categoryIcon: icon.value,
          categoryLabel: context.knobs.string(label: 'Category', initialValue: 'Incidents'),
          title: context.knobs.string(
            label: 'Title',
            initialValue: 'Investigating slow connections in Germany',
          ),
          message: context.knobs.string(
            label: 'Message',
            initialValue:
                'Some residential IPs in Frankfurt are reconnecting more slowly than usually.',
          ),
          timeLabel: context.knobs.string(label: 'Time', initialValue: '12min ago'),
          unread: unread,
          onTap: () {},
        ),
      ),
    ),
  );
}

@UseCase(name: 'List', type: NewsCard)
Widget buildNewsCardList(BuildContext context) => const Center(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: SizedBox(
      width: 343,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          NewsCard(
            categoryIcon: UntitledUI.alert_triangle,
            categoryLabel: 'Incidents',
            title: 'Investigating slow connections in Germany',
            message: 'Some residential IPs in Frankfurt are reconnecting more slowly than usually.',
            timeLabel: '12min ago',
            unread: true,
          ),
          NewsCard(
            categoryIcon: UntitledUI.file_06,
            categoryLabel: 'News',
            title: 'New residential IPs now available across Italy and Spain regions',
            message:
                "We've expanded our residential pool with thousands of new IPs in Milan, Rome, Barcelona …",
            timeLabel: '1d ago',
            unread: true,
          ),
          NewsCard(
            categoryIcon: UntitledUI.alert_triangle,
            categoryLabel: 'Incidents',
            title: 'Sign-in delays on iOS',
            message: 'A short delay affecting iOS sign-ins earlier today has been fully resolved.',
            timeLabel: '3h ago',
          ),
          NewsCard(
            categoryIcon: UntitledUI.tag_01,
            categoryLabel: 'Offers',
            title: 'Save 30% on a 2-year plan - limited-time upgrade offer',
            message: 'Upgrade now and lock in two years of protection at our lowest price.',
            timeLabel: '1 May',
          ),
        ],
      ),
    ),
  ),
);
