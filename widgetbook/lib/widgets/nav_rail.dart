import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

const _icons = <IconData>[UntitledUI.map_01, UntitledUI.star_06, UntitledUI.settings_01];
const _labels = <String>['Map', 'Products', 'Settings'];

@UseCase(name: 'Default', type: NavRail)
Widget buildNavRail(BuildContext context) {
  final selected = context.knobs.object.dropdown(
    label: 'Selected',
    options: const [0, 1, 2],
    initialOption: 0,
    labelBuilder: (i) => _labels[i],
  );
  final topPadding = context.knobs.double.slider(label: 'Top padding', initialValue: 86, max: 200);

  return Align(
    alignment: Alignment.centerLeft,
    child: SizedBox(
      height: 600,
      child: NavRail(
        currentIndex: selected,
        padding: EdgeInsets.only(top: topPadding),
        items: [
          for (var i = 0; i < _icons.length; i++)
            NavRailItem(icon: _icons[i], label: _labels[i], onTap: () {}),
        ],
      ),
    ),
  );
}
