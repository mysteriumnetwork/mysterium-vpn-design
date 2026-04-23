import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('CheckboxItem', () {
    testWidgets('renders label', (tester) async {
      await pumpWidget(
        tester,
        CheckboxItem(value: false, onChanged: () {}, label: const Text('Agree')),
        wrapInScaffold: true,
      );
      expect(find.text('Agree'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('shows checked state', (tester) async {
      await pumpWidget(
        tester,
        CheckboxItem(value: true, onChanged: () {}, label: const Text('Selected')),
        wrapInScaffold: true,
      );
      final cb = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(cb.value, isTrue);
    });

    testWidgets('invokes onChanged when row tapped', (tester) async {
      var toggled = false;
      await pumpWidget(
        tester,
        CheckboxItem(value: false, onChanged: () => toggled = true, label: const Text('Tap me')),
        wrapInScaffold: true,
      );
      await tester.tap(find.text('Tap me'));
      expect(toggled, isTrue);
    });

    testWidgets('null onChanged keeps row non-interactive', (tester) async {
      await pumpWidget(
        tester,
        const CheckboxItem(value: false, onChanged: null, label: Text('Read-only')),
        wrapInScaffold: true,
      );
      await tester.tap(find.text('Read-only'));
      // No callback to assert; absence of exceptions is the pass condition.
      expect(find.text('Read-only'), findsOneWidget);
    });
  });
}
