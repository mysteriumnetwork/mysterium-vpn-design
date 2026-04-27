import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Snackbar', type: Snackbar)
Widget buildSnackbar(BuildContext context) {
  final type = context.knobs.list<SnackbarType>(
    label: 'Type',
    options: SnackbarType.values,
    initialOption: SnackbarType.brand,
    labelBuilder: (t) => t.name,
  );
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'Promo code copied to the clipboard!',
  );
  final showAction = context.knobs.boolean(label: 'Show action', initialValue: false);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Snackbar(
      message: message,
      type: type,
      action: showAction
          ? IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () {})
          : null,
    ),
  );
}
