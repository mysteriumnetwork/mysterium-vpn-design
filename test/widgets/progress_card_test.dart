import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('ProgressCard', () {
    testWidgets('renders header and content when values are provided', (tester) async {
      // arrange
      final widget = ProgressCard(
        icon: Icons.search,
        progressValue: 0.5,
        progressLabel: '3 / 6',
        title: 'Search and connect faster',
        description: 'Quickly find countries, cities and servers with search.',
        actionLabel: 'Continue',
        onActionPressed: () {},
      );

      // act
      await pumpWidget(tester, widget);

      // assert
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('3 / 6'), findsOneWidget);
      expect(find.text('Search and connect faster'), findsOneWidget);
      expect(find.text('Quickly find countries, cities and servers with search.'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('omits header elements when values are null', (tester) async {
      // arrange
      final widget = ProgressCard(actionLabel: 'Continue', onActionPressed: () {});

      // act
      await pumpWidget(tester, widget);

      // assert
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byType(CircleAvatar), findsNothing);
      expect(find.byType(FittedBox), findsNothing);
    });

    testWidgets('invokes onActionPressed when action is tapped', (tester) async {
      // arrange
      var taps = 0;
      final widget = ProgressCard(actionLabel: 'Continue', onActionPressed: () => taps++);

      // act
      await pumpWidget(tester, widget);
      await tester.tap(find.text('Continue'));

      // assert
      expect(taps, 1);
    });

    testWidgets('uses expected background color in light theme', (tester) async {
      // arrange
      final widget = ProgressCard(actionLabel: 'Continue', onActionPressed: () {});

      // act
      await pumpWidget(tester, widget, theme: DesignSystem.lightTheme);

      // assert
      final box = tester.widget<Container>(find.byType(Container).first);
      final decoration = box.decoration! as BoxDecoration;
      expect(decoration.color, Palette.grayLight.shade25);
    });

    testWidgets('uses expected background color in dark theme', (tester) async {
      // arrange
      final widget = ProgressCard(actionLabel: 'Continue', onActionPressed: () {});

      // act
      await pumpWidget(tester, widget, theme: DesignSystem.darkTheme);

      // assert
      final box = tester.widget<Container>(find.byType(Container).first);
      final decoration = box.decoration! as BoxDecoration;
      expect(decoration.color, Palette.grayLight.shade800);
    });
  });
}
