import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('RadioButton (standalone)', () {
    testWidgets('renders as indicator when no onPressed and no group', (tester) async {
      await pumpWidget(tester, const RadioButton<int>(selected: true));
      expect(find.byType(RadioButton<int>), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (tester) async {
      var tapped = false;
      await pumpWidget(tester, RadioButton<int>(value: 1, onPressed: () => tapped = true));
      await tester.tap(find.byType(RadioButton<int>));
      expect(tapped, isTrue);
    });

    testWidgets('renders disabled without error', (tester) async {
      await pumpWidget(
        tester,
        RadioButton<int>(value: 1, enabled: false, selected: true, onPressed: () {}),
      );
      expect(find.byType(RadioButton<int>), findsOneWidget);
    });
  });

  group('RadioButton (in RadioGroup)', () {
    testWidgets('group onChanged fires with the tapped value', (tester) async {
      int? selected;
      await pumpWidget(
        tester,
        RadioGroup<int>(
          groupValue: 1,
          onChanged: (v) => selected = v,
          child: const Row(children: [RadioButton<int>(value: 1), RadioButton<int>(value: 2)]),
        ),
      );
      await tester.tap(find.byType(RadioButton<int>).last);
      expect(selected, equals(2));
    });
  });
}
