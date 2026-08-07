import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool isFavorite = false,
  String? favoriteSemanticLabel,
  String? detailsSemanticLabel,
  String? dismissPreviewSemanticLabel,
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
  isFavorite: isFavorite,
  favoriteSemanticLabel: favoriteSemanticLabel,
  detailsSemanticLabel: detailsSemanticLabel,
  dismissPreviewSemanticLabel: dismissPreviewSemanticLabel,
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

    testWidgets('Connected shows an outline heart by default', (tester) async {
      await pumpWidget(tester, _build(_connected, onFavorite: () {}));
      expect(find.byIcon(UntitledUI.heart), findsOneWidget);
      expect(find.byIcon(UntitledUI.heart_filled), findsNothing);
    });

    testWidgets('Connected shows a filled heart when isFavorite is true', (tester) async {
      await pumpWidget(tester, _build(_connected, onFavorite: () {}, isFavorite: true));
      expect(find.byIcon(UntitledUI.heart_filled), findsOneWidget);
      expect(find.byIcon(UntitledUI.heart), findsNothing);
    });

    testWidgets('announces heart and chevron with caller-supplied semantic labels', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpWidget(
        tester,
        _build(
          _connected,
          onFavorite: () {},
          onDetails: () {},
          favoriteSemanticLabel: 'Save to favourites',
          detailsSemanticLabel: 'Connection details',
        ),
      );
      expect(find.bySemanticsLabel('Save to favourites'), findsOneWidget);
      expect(find.bySemanticsLabel('Connection details'), findsOneWidget);
      semantics.dispose();
    });

    // The card's surface is inverted from the page, so its icons run to full
    // contrast against it: white on the dark card a light page shows, black on
    // the light card a dark page shows.
    for (final (label, isDark, expected) in const [
      ('light', false, Color(0xFFFFFFFF)),
      ('dark', true, Color(0xFF000000)),
    ]) {
      testWidgets('Connected heart is full-contrast against the card ($label)', (tester) async {
        await pumpWidget(
          tester,
          _build(_connected, onFavorite: () {}),
          theme: isDark ? DesignSystem.darkTheme : DesignSystem.lightTheme,
        );
        expect(tester.widget<Icon>(find.byIcon(UntitledUI.heart)).color, expected);
        expect(tester.widget<Icon>(find.byIcon(UntitledUI.chevron_right)).color, expected);
      });
    }

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

    testWidgets('Connected shows the IP in full, truncating the city instead', (tester) async {
      const ip = '203.0.113.5';
      const city = 'Frankfurt am Main Westend-Süd';
      await pumpWidget(
        tester,
        // Real card width, so city and IP genuinely compete for the row
        // (Center supplies loose constraints the SizedBox can shrink into).
        Center(
          child: SizedBox(
            width: 343,
            child: _build(
              const MainIpCardConnected(
                country: 'Germany',
                countryIcon: _flag,
                city: city,
                ipAddress: ip,
              ),
            ),
          ),
        ),
      );

      // didExceedMaxLines is exactly "this Text had to ellipsize".
      bool truncated(String text) =>
          tester.renderObject<RenderParagraph>(find.text(text)).didExceedMaxLines;

      expect(truncated(ip), isFalse, reason: 'the IP address must not be truncated');
      expect(truncated(city), isTrue, reason: 'the city should absorb the truncation');
    });

    testWidgets('Connected places connectedInfoKey on the subtitle row', (tester) async {
      const infoKey = Key('connected-info');
      await pumpWidget(tester, _build(_connected, connectedInfoKey: infoKey));
      expect(find.byKey(infoKey), findsOneWidget);
    });

    testWidgets('Connected disconnect button is solid white in dark theme', (tester) async {
      await pumpWidget(tester, _build(_connected), theme: DesignSystem.darkTheme);
      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.style?.backgroundColor?.resolve({}), Palette.white);
      expect(button.style?.foregroundColor?.resolve({}), Palette.grayLight.shade600);
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

    testWidgets('NewIpPreview announces the dismiss button with its semantic label', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
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
          onDismissPreview: () {},
          dismissPreviewSemanticLabel: 'Dismiss new IP preview',
        ),
      );
      expect(find.bySemanticsLabel('Dismiss new IP preview'), findsOneWidget);
      semantics.dispose();
    });
  });
}
