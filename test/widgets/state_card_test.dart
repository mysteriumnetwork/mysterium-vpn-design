import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('StateCard', () {
    testWidgets('renders the icon and message', (tester) async {
      await pumpWidget(
        tester,
        const StateCard(icon: UntitledUI.log_in_02, message: 'Your are not signed in'),
      );

      expect(find.text('Your are not signed in'), findsOneWidget);
      expect(find.byIcon(UntitledUI.log_in_02), findsOneWidget);
    });

    testWidgets('omits the action when actionLabel is null', (tester) async {
      await pumpWidget(
        tester,
        const StateCard(icon: UntitledUI.log_in_02, message: 'Your are not signed in'),
      );

      expect(find.byType(ButtonTertiary), findsNothing);
    });

    testWidgets('renders the action label when provided', (tester) async {
      await pumpWidget(
        tester,
        StateCard(
          icon: UntitledUI.log_in_02,
          message: 'Your are not signed in',
          actionLabel: 'Sign in',
          onActionPressed: () {},
        ),
      );

      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('invokes onActionPressed when the action is tapped', (tester) async {
      var taps = 0;
      await pumpWidget(
        tester,
        StateCard(
          icon: UntitledUI.log_in_02,
          message: 'Your are not signed in',
          actionLabel: 'Sign in',
          onActionPressed: () => taps++,
        ),
      );

      await tester.tap(find.text('Sign in'));
      expect(taps, 1);
    });

    testWidgets('asserts actionLabel and onActionPressed are paired', (tester) async {
      expect(
        () => StateCard(
          icon: UntitledUI.log_in_02,
          message: 'Your are not signed in',
          actionLabel: 'Sign in',
        ),
        throwsAssertionError,
      );
      expect(
        () => StateCard(
          icon: UntitledUI.log_in_02,
          message: 'Your are not signed in',
          onActionPressed: () {},
        ),
        throwsAssertionError,
      );
    });

    testWidgets('uses palette.bgModals as the card background in light theme', (tester) async {
      await pumpWidget(
        tester,
        const StateCard(icon: UntitledUI.log_in_02, message: 'Your are not signed in'),
        theme: DesignSystem.lightTheme,
      );

      final box = tester.firstWidget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.color, const PaletteLight().bgModals);
    });

    testWidgets('uses palette.bgModals as the card background in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const StateCard(icon: UntitledUI.log_in_02, message: 'Your are not signed in'),
        theme: DesignSystem.darkTheme,
      );

      final box = tester.firstWidget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.color, const PaletteDark().bgModals);
    });
  });
}
