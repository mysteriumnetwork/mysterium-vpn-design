import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('AppDialog', () {
    testWidgets('uses app dialog surface and content padding', (tester) async {
      await pumpWidget(tester, const AppDialog(title: 'Title', width: 343, height: 236));

      final theme = DesignSystem.lightTheme;
      final container = tester.widget<Container>(
        find.descendant(of: find.byType(AppDialog), matching: find.byType(Container)),
      );
      final padding = tester.widget<Padding>(
        find.descendant(of: find.byType(AppDialog), matching: find.byType(Padding)),
      );

      expect(container.color, theme.palette.bgModals);
      expect(container.constraints?.maxWidth, 343);
      expect(container.constraints?.maxHeight, 236);
      expect(padding.padding, EdgeInsets.all(theme.spacing.md));
    });

    testWidgets('uses subscription onboarding typography defaults', (tester) async {
      await pumpWidget(
        tester,
        const AppDialog(title: 'Setup complete', description: 'You are ready to go.'),
      );

      final theme = DesignSystem.lightTheme;
      final title = tester.widget<Text>(find.text('Setup complete'));
      final description = tester.widget<Text>(find.text('You are ready to go.'));

      expect(
        title.style,
        theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textPrimary),
      );
      expect(
        description.style,
        theme.textStyles.textXs.regular.copyWith(color: theme.palette.textTertiary),
      );
    });

    testWidgets('renders emblem and stacked action buttons', (tester) async {
      var primaryPressed = false;
      var secondaryPressed = false;

      await pumpWidget(
        tester,
        AppDialog(
          title: 'Start tour',
          emblem: const Icon(Icons.flag),
          primaryButton: ButtonPrimary(
            onPressed: () => primaryPressed = true,
            child: const Text('Start'),
          ),
          secondaryButton: ButtonTertiary(
            onPressed: () => secondaryPressed = true,
            child: const Text('Skip'),
          ),
        ),
      );

      expect(find.byIcon(Icons.flag), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      await tester.tap(find.text('Start'));
      await tester.tap(find.text('Skip'));

      expect(primaryPressed, isTrue);
      expect(secondaryPressed, isTrue);
    });
  });

  group('ModalAppbar', () {
    testWidgets('renders title when provided', (tester) async {
      await pumpWidget(
        tester,
        const Scaffold(
          appBar: ModalAppbar(title: 'Settings'),
          body: SizedBox.shrink(),
        ),
      );
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders provided actions', (tester) async {
      await pumpWidget(
        tester,
        Scaffold(
          appBar: ModalAppbar(
            actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.star))],
          ),
          body: const SizedBox.shrink(),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('ModalHeader', () {
    testWidgets('renders title', (tester) async {
      await pumpWidget(tester, const ModalHeader(title: 'Title'));
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('renders description when provided', (tester) async {
      await pumpWidget(
        tester,
        const ModalHeader(title: 'Title', description: 'A longer description.'),
      );
      expect(find.text('A longer description.'), findsOneWidget);
    });

    testWidgets('renders emblem when provided', (tester) async {
      await pumpWidget(tester, const ModalHeader(title: 'Title', emblem: Icon(Icons.info)));
      expect(find.byIcon(Icons.info), findsOneWidget);
    });
  });

  group('ModalFooter', () {
    testWidgets('renders its children', (tester) async {
      await pumpWidget(
        tester,
        ModalFooter(
          children: [
            ButtonPrimary(onPressed: () {}, child: const Text('Continue')),
            ButtonSecondary(onPressed: () {}, child: const Text('Cancel')),
          ],
        ),
      );
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });

  group('ModalPadding', () {
    testWidgets('renders child', (tester) async {
      await pumpWidget(tester, const ModalPadding(child: Text('Padded')));
      expect(find.text('Padded'), findsOneWidget);
    });
  });

  group('ModalScaffold', () {
    testWidgets('renders body and default ModalAppbar', (tester) async {
      await pumpWidget(tester, const ModalScaffold(body: Text('Body'), showGradient: false));
      expect(find.text('Body'), findsOneWidget);
      expect(find.byType(ModalAppbar), findsOneWidget);
    });

    testWidgets('renders footer when provided', (tester) async {
      await pumpWidget(
        tester,
        ModalScaffold(
          body: const Text('Body'),
          showGradient: false,
          footer: ModalFooter(
            children: [ButtonPrimary(onPressed: () {}, child: const Text('Done'))],
          ),
        ),
      );
      expect(find.text('Done'), findsOneWidget);
    });
  });
}
