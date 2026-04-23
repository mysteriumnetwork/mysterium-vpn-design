import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('showModal', () {
    testWidgets('presents the builder result', (tester) async {
      late BuildContext capturedContext;
      await pumpWidget(
        tester,
        Builder(
          builder: (context) {
            capturedContext = context;
            return const Text('Home');
          },
        ),
      );

      showModal<void>(capturedContext, builder: (_) => const Text('Modal content'));
      await tester.pumpAndSettle();
      expect(find.text('Modal content'), findsOneWidget);
    });

    testWidgets('wraps child in desktop shell on tablet screenType', (tester) async {
      late BuildContext capturedContext;
      await pumpWidget(
        tester,
        Builder(
          builder: (context) {
            capturedContext = context;
            return const Text('Home');
          },
        ),
        screenType: ScreenType.tablet,
      );

      showModal<void>(
        capturedContext,
        screenType: ScreenType.tablet,
        builder: (_) => const Text('Desktop modal'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Desktop modal'), findsOneWidget);
    });
  });
}
