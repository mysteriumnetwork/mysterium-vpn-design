import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('CustomIconButton', () {
    testWidgets('renders icon', (tester) async {
      await pumpWidget(tester, CustomIconButton(onPressed: () {}, icon: const Icon(Icons.refresh)));
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        CustomIconButton(onPressed: () => tapped = true, icon: const Icon(Icons.refresh)),
      );
      await tester.tap(find.byType(CustomIconButton));
      expect(tapped, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await pumpWidget(tester, const CustomIconButton(onPressed: null, icon: Icon(Icons.refresh)));
      final btn = tester.widget<IconButton>(find.byType(IconButton));
      expect(btn.onPressed, isNull);
    });

    testWidgets('passes tooltip through', (tester) async {
      await pumpWidget(
        tester,
        CustomIconButton(onPressed: () {}, icon: const Icon(Icons.refresh), tooltip: 'Refresh'),
      );
      expect(find.byTooltip('Refresh'), findsOneWidget);
    });
  });
}
