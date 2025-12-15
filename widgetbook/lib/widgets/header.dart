import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Logo', type: Header)
Widget buildLogoHeader(BuildContext context) => _View(
  header: Header.logo(actions: _mockActions(context)),
  canGoBack: context.knobs.boolean(label: 'Has back button'),
);

@UseCase(name: 'Labeled', type: Header)
Widget buildLabeledHeader(BuildContext context) => _View(
  header: Header.labeled(
    label: context.knobs.string(label: 'Title', initialValue: 'Theme'),
    actions: _mockActions(context),
  ),
  canGoBack: context.knobs.boolean(label: 'Has back button'),
);

@UseCase(name: 'Empty', type: Header)
Widget buildEmptyHeader(BuildContext context) => _View(
  header: Header(actions: _mockActions(context)),
  canGoBack: context.knobs.boolean(label: 'Has back button', initialValue: true),
);

List<Widget>? _mockActions(BuildContext context) {
  final iconKnobs = [
    if (context.knobs.boolean(label: 'Show support')) UntitledUI.message_question_square,
    if (context.knobs.boolean(label: 'Show settings')) UntitledUI.settings_01,
  ];

  if (iconKnobs.isEmpty) {
    return null;
  }

  return iconKnobs.map((icon) => IconButton(onPressed: () {}, icon: Icon(icon))).toList();
}

class _View extends StatelessWidget {
  const _View({required this.header, required this.canGoBack});

  final Header header;
  final bool canGoBack;

  @override
  Widget build(BuildContext context) => Navigator(
    onDidRemovePage: (_) {},
    pages: [
      if (canGoBack) const MaterialPage(child: SizedBox.shrink()),
      MaterialPage(
        canPop: false,
        onPopInvoked: (_, _) {},
        allowSnapshotting: false,
        child: Builder(builder: (context) => Scaffold(appBar: header)),
      ),
    ],
  );
}
