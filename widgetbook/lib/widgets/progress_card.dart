import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: ProgressCard)
Widget buildProgressCard(BuildContext context) {
  final actionlabel = context.knobs.string(label: 'Action label', initialValue: 'Continue');
  final progressValue = context.knobs.double.slider(
    label: 'Progress value',
    initialValue: 0.5,
    min: 0,
    max: 1,
  );
  final progressLabel = context.knobs.string(label: 'Progress label', initialValue: '3 / 6');
  final title = context.knobs.string(label: 'Title', initialValue: 'Search and connect faster');
  final description = context.knobs.string(
    label: 'Description',
    initialValue: 'Quickly find countries, cities and servers with search.',
  );

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 343),
        child: ProgressCard(
          actionLabel: actionlabel,
          onActionPressed: () {},
          icon: Icons.search,
          progressValue: progressValue,
          progressLabel: progressLabel,
          title: title,
          description: description,
        ),
      ),
    ),
  );
}
