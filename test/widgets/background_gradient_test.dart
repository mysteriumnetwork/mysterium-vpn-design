import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('BackgroundGradient', () {
    testWidgets('renders child', (tester) async {
      await pumpWidget(tester, const BackgroundGradient(child: Text('content')));
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('skips gradient subtree when showGradient is false', (tester) async {
      await pumpWidget(
        tester,
        const BackgroundGradient(showGradient: false, child: Text('content')),
      );
      expect(find.text('content'), findsOneWidget);
      expect(find.byType(ImageFiltered), findsNothing);
      expect(find.byType(NotificationListener<ScrollNotification>), findsNothing);
    });

    testWidgets('renders blurred gradient subtree when showGradient is true', (tester) async {
      await pumpWidget(tester, const BackgroundGradient(child: Text('content')));
      expect(find.byType(ImageFiltered), findsOneWidget);
      expect(find.byType(NotificationListener<ScrollNotification>), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('rebuilds without error when child scrolls', (tester) async {
      await pumpWidget(
        tester,
        BackgroundGradient(
          child: ListView.builder(
            itemCount: 50,
            itemBuilder: (_, i) => SizedBox(height: 40, child: Text('row $i')),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump();

      expect(find.byType(ImageFiltered), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const BackgroundGradient(child: Text('content')),
        theme: DesignSystem.darkTheme,
      );
      expect(find.text('content'), findsOneWidget);
      expect(find.byType(ImageFiltered), findsOneWidget);
    });
  });
}
