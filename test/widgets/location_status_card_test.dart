import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _flag = SizedBox(width: 36, height: 36);

void main() {
  group('LocationStatusCard', () {
    testWidgets('connected shows lock icon and success colour', (tester) async {
      await pumpWidget(
        tester,
        const LocationStatusCard(
          country: 'Germany',
          city: 'Berlin',
          countryIcon: _flag,
          status: BarStatus.connected,
          statusLabel: 'Connected',
        ),
      );
      expect(find.text('Germany'), findsOneWidget);
      expect(find.text('Berlin'), findsOneWidget);
      expect(find.byIcon(UntitledUI.lock_02), findsOneWidget);
      final label = tester.widget<Text>(find.text('Connected'));
      expect(label.style?.color, DesignSystem.lightTheme.palette.textSuccessTertiary);
    });

    testWidgets('disconnected shows unlocked icon and error colour', (tester) async {
      await pumpWidget(
        tester,
        const LocationStatusCard(
          country: 'Germany',
          countryIcon: _flag,
          status: BarStatus.disconnected,
          statusLabel: 'Disconnected',
        ),
      );
      expect(find.byIcon(UntitledUI.lock_unlocked_01), findsOneWidget);
      final label = tester.widget<Text>(find.text('Disconnected'));
      expect(label.style?.color, DesignSystem.lightTheme.palette.textErrorPrimary);
    });

    testWidgets('gettingIp shows a loading indicator and warning colour', (tester) async {
      await pumpWidget(
        tester,
        const LocationStatusCard(
          country: 'Germany',
          countryIcon: _flag,
          status: BarStatus.gettingIp,
          statusLabel: 'Getting IP address...',
        ),
      );
      expect(find.byType(LoadingIndicator), findsOneWidget);
      final label = tester.widget<Text>(find.text('Getting IP address...'));
      expect(label.style?.color, DesignSystem.lightTheme.palette.textWarningPrimary);
    });

    testWidgets('reserves the city line space when city is null so height stays stable', (
      tester,
    ) async {
      await pumpWidget(
        tester,
        const LocationStatusCard(
          country: 'Germany',
          city: 'Berlin',
          countryIcon: _flag,
          status: BarStatus.connected,
          statusLabel: 'Connected',
        ),
      );
      final heightWithCity = tester.getSize(find.byType(LocationStatusCard)).height;

      await pumpWidget(
        tester,
        const LocationStatusCard(
          country: 'Germany',
          countryIcon: _flag,
          status: BarStatus.connected,
          statusLabel: 'Connected',
        ),
      );
      final heightWithoutCity = tester.getSize(find.byType(LocationStatusCard)).height;

      expect(find.text('Berlin'), findsNothing);
      expect(heightWithoutCity, heightWithCity);
    });

    testWidgets('renders in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const LocationStatusCard(
          country: 'Germany',
          city: 'Berlin',
          countryIcon: _flag,
          status: BarStatus.connected,
          statusLabel: 'Connected',
        ),
        theme: DesignSystem.darkTheme,
      );
      expect(find.text('Germany'), findsOneWidget);
    });
  });
}
