import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// ─── Scrollable content with the gradient behind it ──────────────────────────

@UseCase(name: 'Default', type: BackgroundGradient)
Widget buildBackgroundGradient(BuildContext context) {
  final showGradient = context.knobs.boolean(label: 'Show gradient', initialValue: true);
  final itemCount = context.knobs.int.slider(
    label: 'Item count',
    initialValue: 30,
    min: 5,
    max: 60,
  );
  final palette = Theme.of(context).palette;

  return ColoredBox(
    color: palette.bgPopover,
    child: BackgroundGradient(
      showGradient: showGradient,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text('Scrollable content item $index'),
        ),
      ),
    ),
  );
}

// ─── Static (non-scrolling) child — confirms the gradient stays put ──────────

@UseCase(name: 'Static child', type: BackgroundGradient)
Widget buildBackgroundGradientStatic(BuildContext context) {
  final showGradient = context.knobs.boolean(label: 'Show gradient', initialValue: true);
  final theme = Theme.of(context);

  return ColoredBox(
    color: theme.palette.bgPopover,
    child: BackgroundGradient(
      showGradient: showGradient,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Hello from in front of the gradient',
            style: theme.textStyles.textLg.semibold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

// ─── Inside a ModalScaffold — primary real-world usage ───────────────────────

@UseCase(name: 'Inside ModalScaffold', type: BackgroundGradient)
Widget buildBackgroundGradientInModal(BuildContext context) {
  final showGradient = context.knobs.boolean(label: 'Show gradient', initialValue: true);
  final theme = Theme.of(context);

  return ModalScaffold(
    showGradient: showGradient,
    body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 30,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('Modal content row $index', style: theme.textStyles.textMd.regular),
      ),
    ),
  );
}
