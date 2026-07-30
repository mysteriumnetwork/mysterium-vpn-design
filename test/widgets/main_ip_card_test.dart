import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _flag = SizedBox(width: 32, height: 32);

MainIpCard _build(
  MainIpCardStatus status, {
  VoidCallback? onConnect,
  VoidCallback? onDisconnect,
  VoidCallback? onDetails,
  VoidCallback? onFavorite,
  VoidCallback? onSwitchCountry,
  VoidCallback? onDismissPreview,
  Key? connectedInfoKey,
  SingleWidgetWrapper? buttonWrapper,
}) => MainIpCard(
  status: status,
  connectLabel: 'Connect',
  disconnectLabel: 'Disconnect',
  connectingLabel: 'Connecting…',
  noConnectionTitle: 'Not connected',
  noConnectionDescription: 'Pick a country to begin',
  onConnect: onConnect,
  onDisconnect: onDisconnect,
  onDetails: onDetails,
  onFavorite: onFavorite,
  onSwitchCountry: onSwitchCountry,
  onDismissPreview: onDismissPreview,
  connectedInfoKey: connectedInfoKey,
  buttonWrapper: buttonWrapper,
);

const _connected = MainIpCardConnected(
  country: 'Germany',
  countryIcon: _flag,
  city: 'Frankfurt',
  ipAddress: '203.0.113.5',
);

void main() {
  group('MainIpCard', () {
    testWidgets('NotConnected renders title, description and connect button', (tester) async {
      var connected = false;
      await pumpWidget(
        tester,
        _build(const MainIpCardNotConnected(), onConnect: () => connected = true),
      );
      expect(find.text('Not connected'), findsOneWidget);
      expect(find.text('Pick a country to begin'), findsOneWidget);
      await tester.tap(find.text('Connect'));
      expect(connected, isTrue);
    });

    testWidgets('LocationSelected renders country and fires onConnect', (tester) async {
      var connected = false;
      await pumpWidget(
        tester,
        _build(
          const MainIpCardLocationSelected(
            country: 'Germany',
            countryIcon: _flag,
            serviceQuality: 'Excellent',
          ),
          onConnect: () => connected = true,
        ),
      );
      expect(find.text('Germany'), findsOneWidget);
      expect(find.text('Excellent'), findsOneWidget);
      await tester.tap(find.text('Connect'));
      expect(connected, isTrue);
    });

    testWidgets('Connecting renders connecting label', (tester) async {
      await pumpWidget(
        tester,
        _build(
          const MainIpCardConnecting(
            country: 'Germany',
            countryIcon: _flag,
            serviceQuality: 'Excellent',
          ),
        ),
      );
      expect(find.text('Connecting…'), findsWidgets);
    });

    testWidgets('Connected renders location, IP and fires onDisconnect', (tester) async {
      var disconnected = false;
      await pumpWidget(tester, _build(_connected, onDisconnect: () => disconnected = true));
      expect(find.text('Germany'), findsOneWidget);
      expect(find.text('Frankfurt'), findsOneWidget);
      expect(find.text('203.0.113.5'), findsOneWidget);
      await tester.tap(find.text('Disconnect'));
      expect(disconnected, isTrue);
    });

    testWidgets('Connected fires onDetails from the chevron', (tester) async {
      var details = false;
      await pumpWidget(tester, _build(_connected, onDetails: () => details = true));
      await tester.tap(find.byIcon(UntitledUI.chevron_right));
      expect(details, isTrue);
    });

    testWidgets('Connected fires onFavorite from the heart', (tester) async {
      var favorite = false;
      await pumpWidget(tester, _build(_connected, onFavorite: () => favorite = true));
      await tester.tap(find.byIcon(UntitledUI.heart));
      expect(favorite, isTrue);
    });

    testWidgets('Connected hides the heart when onFavorite is null', (tester) async {
      await pumpWidget(tester, _build(_connected));
      expect(find.byIcon(UntitledUI.heart), findsNothing);
    });

    testWidgets('Connected omits the city divider when city is empty', (tester) async {
      await pumpWidget(
        tester,
        _build(
          const MainIpCardConnected(
            country: 'Germany',
            countryIcon: _flag,
            city: '',
            ipAddress: '203.0.113.5',
          ),
        ),
      );
      expect(find.text('203.0.113.5'), findsOneWidget);
      expect(find.text(''), findsNothing);
    });

    testWidgets('Connected places connectedInfoKey on the subtitle row', (tester) async {
      const infoKey = Key('connected-info');
      await pumpWidget(tester, _build(_connected, connectedInfoKey: infoKey));
      expect(find.byKey(infoKey), findsOneWidget);
    });

    testWidgets('Connected renders in dark theme', (tester) async {
      await pumpWidget(
        tester,
        _build(_connected, onFavorite: () {}),
        theme: DesignSystem.darkTheme,
      );
      expect(find.text('Germany'), findsOneWidget);
      expect(find.byIcon(UntitledUI.heart), findsOneWidget);
    });

    testWidgets('buttonWrapper wraps the main action button', (tester) async {
      const wrapperKey = Key('main-ip-card-action-wrapper');
      var connected = false;
      await pumpWidget(
        tester,
        _build(
          const MainIpCardNotConnected(),
          onConnect: () => connected = true,
          buttonWrapper: ({required context, required child}) =>
              KeyedSubtree(key: wrapperKey, child: child),
        ),
      );

      expect(
        find.ancestor(of: find.text('Connect'), matching: find.byKey(wrapperKey)),
        findsOneWidget,
      );

      await tester.tap(find.text('Connect'));
      expect(connected, isTrue);
    });

    testWidgets('NewIpPreview renders preview country and main switch label', (tester) async {
      var switched = false;
      await pumpWidget(
        tester,
        _build(
          const MainIpCardNewIpPreview(
            country: 'Germany',
            countryIcon: _flag,
            city: 'Frankfurt',
            ipAddress: '203.0.113.5',
            previewCountry: 'Poland',
            previewCountryIcon: _flag,
            switchLabel: 'Switch to Poland',
          ),
          onSwitchCountry: () => switched = true,
        ),
      );
      expect(find.text('Poland'), findsOneWidget);
      expect(find.text('Switch to Poland'), findsOneWidget);
      await tester.tap(find.text('Switch to Poland'));
      expect(switched, isTrue);
    });
  });
}
