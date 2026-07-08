import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _flag = SizedBox(width: 32, height: 32);

MainIpCard _build(
  MainIpCardStatus status, {
  ConnectionRating rating = ConnectionRating.none,
  bool showConnectionRating = true,
  VoidCallback? onConnect,
  VoidCallback? onDisconnect,
  VoidCallback? onSwitchCountry,
  VoidCallback? onDismissPreview,
  VoidCallback? onThumbsUp,
  VoidCallback? onThumbsDown,
  VoidCallback? onRefreshIp,
  SingleWidgetWrapper? buttonWrapper,
}) => MainIpCard(
  status: status,
  connectLabel: 'Connect',
  disconnectLabel: 'Disconnect',
  connectingLabel: 'Connecting…',
  noConnectionTitle: 'Not connected',
  noConnectionDescription: 'Pick a country to begin',
  connectionRatingLabel: 'Rate this connection',
  refreshIpTooltip: 'Refresh IP',
  connectionRating: rating,
  showConnectionRating: showConnectionRating,
  onConnect: onConnect,
  onDisconnect: onDisconnect,
  onSwitchCountry: onSwitchCountry,
  onDismissPreview: onDismissPreview,
  onThumbsUp: onThumbsUp,
  onThumbsDown: onThumbsDown,
  onRefreshIp: onRefreshIp,
  buttonWrapper: buttonWrapper,
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

    testWidgets('Connected renders details and fires onDisconnect', (tester) async {
      var disconnected = false;
      await pumpWidget(
        tester,
        _build(
          const MainIpCardConnected(
            country: 'Germany',
            countryIcon: _flag,
            city: 'Frankfurt',
            ipAddress: '203.0.113.5',
            serviceQuality: 'Excellent',
            ipPoolCount: 3,
          ),
          onDisconnect: () => disconnected = true,
        ),
      );
      expect(find.text('Germany'), findsOneWidget);
      expect(find.text('Frankfurt'), findsOneWidget);
      expect(find.text('203.0.113.5'), findsOneWidget);
      expect(find.text('IP pool: 3'), findsOneWidget);
      await tester.tap(find.text('Disconnect'));
      expect(disconnected, isTrue);
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
            serviceQuality: 'Excellent',
            ipPoolCount: 3,
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

    testWidgets('Connected omits rating row when showConnectionRating is false', (tester) async {
      await pumpWidget(
        tester,
        _build(
          const MainIpCardConnected(
            country: 'Germany',
            countryIcon: _flag,
            city: 'Frankfurt',
            ipAddress: '203.0.113.5',
            serviceQuality: 'Excellent',
            ipPoolCount: 3,
          ),
          showConnectionRating: false,
        ),
      );
      expect(find.text('Rate this connection'), findsNothing);
    });

    testWidgets('NewIpPreview omits rating row when showConnectionRating is false', (tester) async {
      await pumpWidget(
        tester,
        _build(
          const MainIpCardNewIpPreview(
            country: 'Germany',
            countryIcon: _flag,
            city: 'Frankfurt',
            ipAddress: '203.0.113.5',
            serviceQuality: 'Excellent',
            ipPoolCount: 3,
            previewCountry: 'Poland',
            previewCountryIcon: _flag,
            switchLabel: 'Switch to Poland',
          ),
          showConnectionRating: false,
        ),
      );
      expect(find.text('Rate this connection'), findsNothing);
    });
  });
}
