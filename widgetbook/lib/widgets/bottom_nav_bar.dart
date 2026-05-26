import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

const _items = <BottomNavBarItem>[
  BottomNavBarItem(icon: UntitledUI.map_01, label: 'Map'),
  BottomNavBarItem(icon: UntitledUI.flag_01, label: 'Locations'),
  BottomNavBarItem(icon: UntitledUI.star_06, label: 'Products'),
  BottomNavBarItem(icon: UntitledUI.settings_01, label: 'Settings'),
];

@UseCase(name: 'Default', type: BottomNavBar)
Widget buildBottomNavBar(BuildContext context) {
  final selected = context.knobs.object.dropdown(
    label: 'Selected',
    options: const [0, 1, 2, 3],
    initialOption: 0,
    labelBuilder: (i) => _items[i].label,
  );

  return Align(
    alignment: Alignment.bottomCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 448),
      child: BottomNavBar(selectedIndex: selected, onDestinationSelected: (_) {}, items: _items),
    ),
  );
}
