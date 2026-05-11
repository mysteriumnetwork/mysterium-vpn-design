import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Sandbox', type: StateCard)
Widget buildStateCardSandbox(BuildContext context) {
  final showAction = context.knobs.boolean(label: 'Show action', initialValue: true);
  final message = context.knobs.string(label: 'Message', initialValue: 'You are not signed in');
  final actionLabel = context.knobs.string(label: 'Action label', initialValue: 'Sign in');

  return Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 343),
        child: StateCard(
          icon: UntitledUI.log_in_02,
          message: message,
          actionLabel: showAction ? actionLabel : null,
          onActionPressed: showAction ? () {} : null,
        ),
      ),
    ),
  );
}

@UseCase(name: 'Without action', type: StateCard)
Widget buildStateCardNoAction(BuildContext context) => Padding(
  padding: const EdgeInsets.all(24),
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 343),
      child: const StateCard(icon: UntitledUI.bell_01, message: 'No new notifications'),
    ),
  ),
);
