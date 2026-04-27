import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'ModalHeader', type: ModalHeader)
Widget buildModalHeader(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Stay updated by email');
  final description = context.knobs.stringOrNull(
    label: 'Description',
    initialValue:
        'Would you like to receive email updates, privacy tips, and special offers from Mysterium Network?',
  );
  final showEmblem = context.knobs.boolean(label: 'Show emblem', initialValue: true);
  return Padding(
    padding: const EdgeInsets.all(24),
    child: ModalHeader(
      title: title,
      description: description,
      emblem: showEmblem
          ? Icon(UntitledUI.mail_01, size: 80, color: Theme.of(context).palette.iconBrandSecondary)
          : null,
    ),
  );
}
