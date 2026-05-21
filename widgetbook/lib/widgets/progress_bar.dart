import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Horizontal', type: ProgressBar)
Widget buildHorizontalProgressBar(BuildContext context) =>
    HorizontalProgressBar(theme: ProgressBarTheme.light, value: 0.5);

@UseCase(name: 'Circular', type: ProgressBar)
Widget buildCircularProgressBar(BuildContext context) =>
    CircularProgressBar(theme: ProgressBarTheme.light, value: 0.5);
