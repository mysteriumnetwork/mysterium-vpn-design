import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('DetailCard', () {
    testWidgets('renders title and value', (tester) async {
      await pumpWidget(tester, const DetailCard(title: 'VPN IP', value: '203.0.113.5'));
      expect(find.text('VPN IP'), findsOneWidget);
      expect(find.text('203.0.113.5'), findsOneWidget);
    });

    testWidgets('muted value uses the tertiary text colour', (tester) async {
      await pumpWidget(tester, const DetailCard(title: 'My IP', value: 'Hidden', valueMuted: true));
      final value = tester.widget<Text>(find.text('Hidden'));
      final palette = DesignSystem.lightTheme.palette;
      expect(value.style?.color, palette.textTertiary);
    });

    testWidgets('renders valueIcon and trailing widgets', (tester) async {
      await pumpWidget(
        tester,
        const DetailCard(
          title: 'My IP',
          value: 'Hidden',
          valueIcon: Icon(UntitledUI.eye_off, size: 24),
          trailing: Icon(UntitledUI.refresh_cw_02, size: 20),
        ),
      );
      expect(find.byIcon(UntitledUI.eye_off), findsOneWidget);
      expect(find.byIcon(UntitledUI.refresh_cw_02), findsOneWidget);
    });

    testWidgets('top and middle positions draw a bottom separator', (tester) async {
      for (final position in SettingsCardPosition.values) {
        await pumpWidget(tester, DetailCard(title: 'Row', value: 'Value', position: position));
        final expectsBorder =
            position == SettingsCardPosition.top || position == SettingsCardPosition.middle;
        expect(
          find.byType(Positioned),
          expectsBorder ? findsOneWidget : findsNothing,
          reason: 'position: $position',
        );
      }
    });

    testWidgets('renders in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const DetailCard(title: 'Protocol', value: 'WireGuard'),
        theme: DesignSystem.darkTheme,
      );
      expect(find.text('Protocol'), findsOneWidget);
      expect(find.text('WireGuard'), findsOneWidget);
    });
  });
}
