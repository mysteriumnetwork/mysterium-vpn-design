import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('Snackbar', () {
    testWidgets('renders message', (tester) async {
      await pumpWidget(tester, const Snackbar(message: 'Promo code copied'));
      expect(find.text('Promo code copied'), findsOneWidget);
    });

    testWidgets('all types render without error', (tester) async {
      for (final type in SnackbarType.values) {
        await pumpWidget(tester, Snackbar(message: type.name, type: type));
        expect(find.text(type.name), findsOneWidget);
      }
    });

    testWidgets('renders action when provided', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        Snackbar(
          message: 'With action',
          action: IconButton(icon: const Icon(Icons.close), onPressed: () => tapped = true),
        ),
      );
      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      expect(tapped, isTrue);
    });

    testWidgets('omits action when null', (tester) async {
      await pumpWidget(tester, const Snackbar(message: 'No action'));
      expect(find.byType(IconButton), findsNothing);
    });
  });
}
