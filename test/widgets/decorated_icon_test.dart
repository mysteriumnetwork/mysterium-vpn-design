import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('DecoratedIcon', () {
    testWidgets('renders icon with default decoration', (tester) async {
      await pumpWidget(tester, const DecoratedIcon(icon: Icons.star));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('applies custom decoration', (tester) async {
      await pumpWidget(
        tester,
        const DecoratedIcon(
          icon: Icons.home,
          decoration: IconDecoration(iconSize: 32, iconColor: Colors.red),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.size, 32);
      expect(icon.color, Colors.red);
    });
  });
}
