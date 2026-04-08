import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'SearchField', type: SearchField)
Widget buildSearchField(BuildContext context) => Padding(
  padding: const EdgeInsets.all(16),
  child: SearchField(
    placeholder: context.knobs.string(label: 'Placeholder', initialValue: 'Search locations'),
  ),
);
