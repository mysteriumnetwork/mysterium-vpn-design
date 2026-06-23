import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('RefreshIconButton', () {
    testWidgets('renders the default refresh glyph and fires onPressed', (tester) async {
      var taps = 0;
      await pumpWidget(tester, RefreshIconButton(onPressed: () => taps++));

      expect(find.byIcon(UntitledUI.refresh_cw_05), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await pumpWidget(tester, const RefreshIconButton());
      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('spins while spinning is true', (tester) async {
      await pumpWidget(tester, const RefreshIconButton(spinning: true));

      // A continuous rotation animation keeps the tree dirty while spinning.
      expect(find.byType(RotationTransition), findsOneWidget);
      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('does not animate when not spinning', (tester) async {
      await pumpWidget(tester, const RefreshIconButton());
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
