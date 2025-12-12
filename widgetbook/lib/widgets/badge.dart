import 'package:flutter/material.dart' hide Badge;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Badge', type: Badge)
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

  return Badge(text: text, type: type, size: size);
}
