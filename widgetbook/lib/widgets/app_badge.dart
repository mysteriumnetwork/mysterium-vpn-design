import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'Badge', type: AppBadge)
Widget buildBadge(BuildContext context) {
  final text = context.knobs.string(label: 'Text', initialValue: 'Badge');
  final type = context.knobs.object.dropdown(
    label: 'Type',
    initialOption: BadgeType.neutral,
    options: BadgeType.values,
    labelBuilder: (type) => type.name,
  );

  final size = context.knobs.object.dropdown(
    label: 'Size',
    initialOption: BadgeSize.medium,
    options: BadgeSize.values,
    labelBuilder: (size) => size.name,
  );

  final icon = context.knobs.objectOrNull.dropdown<IconData>(
    label: 'Leading icon',
    options: WidgetbookUtils.icons,
    labelBuilder: WidgetbookUtils.iconName,
  );
  final tooltip = context.knobs.stringOrNull(label: 'Tooltip');

  return AppBadge(text: text, type: type, size: size, icon: icon, tooltip: tooltip);
}
