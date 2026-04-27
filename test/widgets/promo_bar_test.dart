import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('PromoBar', () {
    testWidgets('renders text', (tester) async {
      await pumpWidget(tester, const PromoBar(text: 'Upgrade today'));
      expect(find.text('Upgrade today'), findsOneWidget);
    });

    testWidgets('renders leading icon when provided', (tester) async {
      await pumpWidget(tester, const PromoBar(text: 'Promo', icon: Icon(Icons.star)));
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await pumpWidget(tester, PromoBar(text: 'Tap me', onTap: () => tapped = true));
      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('hides trailing chevron when onTap is null', (tester) async {
      await pumpWidget(tester, const PromoBar(text: 'Read only'));
      expect(find.byType(IconButton), findsNothing);
    });
  });
}
