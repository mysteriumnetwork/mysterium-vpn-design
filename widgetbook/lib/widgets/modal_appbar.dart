import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ModalAppbar', type: ModalAppbar)
Widget buildModalAppbar(BuildContext context) {
  final title = context.knobs.stringOrNull(label: 'Title', initialValue: 'Modal title');
  final showCloseButton = context.knobs.boolean(label: 'Show close button', initialValue: true);
  final showActions = context.knobs.boolean(label: 'Show actions');
  return Scaffold(
    appBar: ModalAppbar(
      title: title,
      showCloseButton: showCloseButton,
      actions: showActions
          ? [CustomIconButton(onPressed: () {}, icon: const Icon(UntitledUI.dots_vertical))]
          : null,
    ),
    body: const Center(child: Text('Body content')),
  );
}
