import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'SearchField', type: SearchField)
Widget buildSearchField(BuildContext context) {
  final placeholder = context.knobs.string(label: 'Placeholder', initialValue: 'Search locations');
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);
  // Button mode: the field renders identically but acts as a tap target.
  final buttonMode = context.knobs.boolean(label: 'Button mode');

  return Padding(
    padding: const EdgeInsets.all(16),
    child: SearchField(
      placeholder: placeholder,
      enabled: enabled,
      onTap: buttonMode ? () {} : null,
    ),
  );
}
