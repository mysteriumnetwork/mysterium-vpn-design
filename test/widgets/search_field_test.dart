import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('SearchField', () {
    testWidgets('renders placeholder', (tester) async {
      await pumpWidget(
        tester,
        const Material(child: SearchField(placeholder: 'Search locations...')),
      );
      expect(find.text('Search locations...'), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? lastValue;
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', onChanged: (v) => lastValue = v),
        ),
      );
      await tester.enterText(find.byType(TextField), 'hello');
      expect(lastValue, 'hello');
    });

    testWidgets('calls onSubmitted on keyboard submit', (tester) async {
      String? submitted;
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', onSubmitted: (v) => submitted = v),
        ),
      );
      await tester.enterText(find.byType(TextField), 'query');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'query');
    });

    testWidgets('uses provided TextEditingController', (tester) async {
      final controller = TextEditingController(text: 'initial');
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', controller: controller),
        ),
      );
      expect(find.text('initial'), findsOneWidget);
      controller.dispose();
    });
  });
}
