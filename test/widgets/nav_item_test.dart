import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('NavItem', () {
    testWidgets('renders icon and label', (tester) async {
      await pumpWidget(tester, const NavItem(icon: Icon(Icons.settings), label: 'Settings'));
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        NavItem(icon: const Icon(Icons.home), label: 'Home', onTap: () => tapped = true),
      );
      await tester.tap(find.text('Home'));
      expect(tapped, isTrue);
    });

    testWidgets('renders trailing widget', (tester) async {
      await pumpWidget(
        tester,
        const NavItem(icon: Icon(Icons.link), label: 'External', trailing: Icon(Icons.open_in_new)),
      );
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('current=true renders without error', (tester) async {
      await pumpWidget(
        tester,
        NavItem(icon: const Icon(Icons.home), label: 'Home', current: true, onTap: () {}),
      );
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('no onTap means not interactive', (tester) async {
      await pumpWidget(tester, const NavItem(icon: Icon(Icons.home), label: 'Home'));
      // Tapping should not throw
      await tester.tap(find.text('Home'));
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
