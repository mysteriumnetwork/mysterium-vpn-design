import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('MaterialWrapper', () {
    testWidgets('renders child', (tester) async {
      await pumpWidget(tester, const MaterialWrapper(child: Text('Wrapped')));
      expect(find.text('Wrapped'), findsOneWidget);
    });

    testWidgets('renders with custom color and borderRadius', (tester) async {
      await pumpWidget(
        tester,
        const MaterialWrapper(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.kS),
          child: Text('Styled'),
        ),
      );
      expect(find.text('Styled'), findsOneWidget);
    });
  });

  group('TooltipIcon', () {
    testWidgets('renders default icon', (tester) async {
      await pumpWidget(tester, const TooltipIcon(message: 'Help text'));
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('renders with custom icon', (tester) async {
      await pumpWidget(tester, const TooltipIcon(message: 'Info', icon: Icons.info));
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('.titled renders without error', (tester) async {
      await pumpWidget(tester, TooltipIcon.titled(title: 'Title', body: 'Body content'));
      expect(find.byType(Tooltip), findsOneWidget);
    });
  });
}
