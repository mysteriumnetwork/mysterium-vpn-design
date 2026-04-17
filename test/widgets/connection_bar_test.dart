import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('ConnectionBar', () {
    const base = ConnectionBar(
      label: 'Connected',
      killSwitchLabel: 'Kill Switch',
      killSwitchDescription: 'Blocks traffic when VPN drops',
      status: BarStatus.connected,
    );

    testWidgets('renders label', (tester) async {
      await pumpWidget(tester, base, wrapInScaffold: true);
      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('all statuses render without error', (tester) async {
      for (final status in BarStatus.values) {
        await pumpWidget(
          tester,
          ConnectionBar(
            label: status.name,
            killSwitchLabel: 'KS',
            killSwitchDescription: 'Desc',
            status: status,
          ),
          wrapInScaffold: true,
        );
        expect(find.text(status.name), findsOneWidget);
      }
    });

    testWidgets('expands on tap when connected', (tester) async {
      await pumpWidget(tester, base, wrapInScaffold: true);

      // Kill switch description hidden initially
      expect(find.text('Blocks traffic when VPN drops'), findsNothing);

      // Tap to expand
      await tester.tap(find.text('Connected'));
      await tester.pumpAndSettle();

      // Kill switch row visible
      expect(find.text('Kill Switch'), findsOneWidget);
      expect(find.text('Blocks traffic when VPN drops'), findsOneWidget);
    });

    testWidgets('does not expand when disconnected', (tester) async {
      await pumpWidget(
        tester,
        const ConnectionBar(
          label: 'Disconnected',
          killSwitchLabel: 'KS',
          killSwitchDescription: 'Desc',
          status: BarStatus.disconnected,
        ),
        wrapInScaffold: true,
      );
      await tester.tap(find.text('Disconnected'));
      await tester.pumpAndSettle();

      // Kill switch description should remain hidden
      expect(find.text('Desc'), findsNothing);
    });

    testWidgets('collapses when status changes from connected', (tester) async {
      final statusNotifier = ValueNotifier(BarStatus.connected);
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystem.lightTheme,
          home: ScreenTypeOverride(
            screenType: ScreenType.mobile,
            child: Scaffold(
              body: ValueListenableBuilder<BarStatus>(
                valueListenable: statusNotifier,
                builder: (_, status, _) => ConnectionBar(
                  label: 'Label',
                  killSwitchLabel: 'KS',
                  killSwitchDescription: 'Desc',
                  status: status,
                ),
              ),
            ),
          ),
        ),
      );

      // Expand
      await tester.tap(find.text('Label'));
      await tester.pumpAndSettle();
      expect(find.text('Desc'), findsOneWidget);

      // Change status to disconnected
      statusNotifier.value = BarStatus.disconnected;
      await tester.pumpAndSettle();

      // Should auto-collapse
      expect(find.text('Desc'), findsNothing);

      statusNotifier.dispose();
    });
  });
}
