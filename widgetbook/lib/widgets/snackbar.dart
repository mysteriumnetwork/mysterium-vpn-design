import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Snackbar', type: Snackbar)
Widget buildSnackbar(BuildContext context) {
  final type = context.knobs.object.dropdown<SnackbarType>(
    label: 'Type',
    options: SnackbarType.values,
    initialOption: SnackbarType.brand,
    labelBuilder: (t) => t.name,
  );
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'Promo code copied to the clipboard!',
  );
  // Text actions (e.g. "Undo") take their colour and hover from the inverted
  // theme the Snackbar supplies, so they are worth previewing in both modes.
  final action = context.knobs.object.dropdown<_ActionKind>(
    label: 'Action',
    initialOption: _ActionKind.none,
    options: _ActionKind.values,
    labelBuilder: (it) => it.name,
  );
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Snackbar(
      message: message,
      type: type,
      action: switch (action) {
        _ActionKind.none => null,
        _ActionKind.textButton => ButtonTertiary(
          onPressed: () {},
          size: ButtonSize.small,
          child: const Text('Undo'),
        ),
        _ActionKind.iconButton => IconButton(
          icon: const Icon(Icons.close, size: 16),
          onPressed: () {},
        ),
      },
    ),
  );
}

enum _ActionKind { none, textButton, iconButton }
