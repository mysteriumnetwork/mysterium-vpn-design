import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: LoadingIndicator)
Widget buildLoadingIndicator(BuildContext context) {
  final size = context.knobs.double.slider(label: 'Size', initialValue: 24, min: 8, max: 64);

  return Center(child: LoadingIndicator(size: size));
}

@UseCase(name: 'Custom color', type: LoadingIndicator)
Widget buildLoadingIndicatorCustomColor(BuildContext context) =>
    Center(child: LoadingIndicator(color: Theme.of(context).palette.textBrandPrimary));
