import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/widgets/logo.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Logo', type: Logo)
Widget buildLogo(BuildContext context) => Logo(
  width: context.knobs.doubleOrNull.input(label: 'Width'),
  height: context.knobs.doubleOrNull.input(label: 'Height'),
);
