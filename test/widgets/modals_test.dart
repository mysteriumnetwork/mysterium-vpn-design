import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
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
