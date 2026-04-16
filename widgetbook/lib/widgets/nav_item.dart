import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: NavItem)
Widget buildNavItem(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Settings',
  );
  final current = context.knobs.boolean(label: 'Current');

  return Center(
    child: SizedBox(
      width: 272,
      child: NavItem(
        icon: const Icon(UntitledUI.settings_03),
        label: label,
        current: current,
        onTap: () {},
      ),
    ),
  );
}

@UseCase(name: 'Group', type: NavItem)
Widget buildNavItemGroup(BuildContext context) => Center(
      child: SizedBox(
        width: 272,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavItem(
              icon: const Icon(UntitledUI.settings_03),
              label: 'Settings',
              current: true,
              onTap: () {},
            ),
            NavItem(
              icon: const Icon(UntitledUI.message_question_square),
              label: 'Support',
              onTap: () {},
            ),
            NavItem(
              icon: const Icon(UntitledUI.arrow_narrow_left),
              label: 'Back to home',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
