import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: NavItem)
Widget buildNavItem(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Settings');
  final current = context.knobs.boolean(label: 'Current');

  return _sidePanel(
    context,
    child: NavItem(
      icon: const Icon(UntitledUI.settings_03),
      label: label,
      current: current,
      onTap: () {},
    ),
  );
}

@UseCase(name: 'Group', type: NavItem)
Widget buildNavItemGroup(BuildContext context) => _sidePanel(
  context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      NavItem(
        icon: const Icon(UntitledUI.settings_03),
        label: 'Settings',
        current: true,
        onTap: () {},
      ),
      NavItem(icon: const Icon(UntitledUI.message_question_square), label: 'Support', onTap: () {}),
      NavItem(icon: const Icon(UntitledUI.arrow_narrow_left), label: 'Back to home', onTap: () {}),
    ],
  ),
);

/// NavItem's hover token is tuned for the sidebar surface, so the use-cases
/// render on it rather than on the default canvas.
Widget _sidePanel(BuildContext context, {required Widget child}) => ColoredBox(
  color: Theme.of(context).palette.bgSidePanel,
  child: Center(
    child: SizedBox(
      width: 272,
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 24), child: child),
    ),
  ),
);
