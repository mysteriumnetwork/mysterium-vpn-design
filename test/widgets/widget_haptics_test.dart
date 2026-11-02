import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/haptics.dart';
import '../helpers/pump_widget.dart';

/// Policy under test: see `docs/haptics.md`. A tap fires only when it changes
/// state in the world or commits something; moving the view stays silent.
const _selection = 'HapticFeedbackType.selectionClick';
const _impact = 'HapticFeedbackType.mediumImpact';

const _flag = SizedBox(width: 32, height: 32);

const _navItems = <BottomNavBarItem>[
  BottomNavBarItem(icon: UntitledUI.map_01, label: 'Map'),
  BottomNavBarItem(icon: UntitledUI.settings_01, label: 'Settings'),
];

const _offerData = PlanData(
  name: 'Offer',
  fullPriceLabel: 'Total',
  fullPrice: r'$49',
  periodLabel: '/year',
  perMonth: '/mo',
  promoBadge: '50% OFF',
  isOffer: true,
);

MainIpCard _mainIpCard({
  required MainIpCardStatus status,
  VoidCallback? onConnect,
  VoidCallback? onDisconnect,
  VoidCallback? onDetails,
  VoidCallback? onFavorite,
}) => MainIpCard(
  status: status,
  connectLabel: 'Connect',
  disconnectLabel: 'Disconnect',
  connectingLabel: 'Connecting…',
  noConnectionTitle: 'Not connected',
  noConnectionDescription: 'Pick a country',
  onConnect: onConnect,
  onDisconnect: onDisconnect,
  onDetails: onDetails,
  onFavorite: onFavorite,
);

const _connected = MainIpCardConnected(
  country: 'Germany',
  countryIcon: _flag,
  city: 'Frankfurt',
  ipAddress: '203.0.113.5',
);

void main() {
  group('Button is silent unless it opts in', () {
    testWidgets('no haptic by default', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, ButtonPrimary(onPressed: () {}, child: const Text('Go')));

      await tester.tap(find.text('Go'));

      expect(fired, isEmpty);
    });

    testWidgets('opting in to impact fires impact', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        ButtonPrimary(onPressed: () {}, haptic: HapticLevel.impact, child: const Text('Connect')),
      );

      await tester.tap(find.text('Connect'));

      expect(fired, [_impact]);
    });

    testWidgets('opting in still invokes onPressed', (tester) async {
      final fired = recordHaptics(tester);
      var pressed = false;
      await pumpWidget(
        tester,
        ButtonSecondary(
          onPressed: () => pressed = true,
          haptic: HapticLevel.selection,
          child: const Text('Pick'),
        ),
      );

      await tester.tap(find.text('Pick'));

      expect(pressed, isTrue);
      expect(fired, [_selection]);
    });

    testWidgets('disabled stays silent', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        const ButtonPrimary(onPressed: null, haptic: HapticLevel.impact, child: Text('Off')),
      );

      await tester.tap(find.text('Off'));

      expect(fired, isEmpty);
    });
  });

  group('A value change fires selection', () {
    testWidgets('LocationCard', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        LocationCard(
          icon: const Icon(Icons.flag),
          name: 'Germany',
          subtitle: 'Berlin',
          onTap: () {},
        ),
      );

      await tester.tap(find.text('Germany'));

      expect(fired, [_selection]);
    });

    testWidgets('SavedIpCard row and its favourite heart', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        SavedIpCard(
          countryIcon: const ColoredBox(color: Colors.red),
          name: 'Albania',
          subtitle: 'Tirana',
          ipAddress: '195.285.15.404',
          badgeLabel: 'Residential IP',
          onTap: () {},
          onFavoriteTap: () {},
        ),
      );

      await tester.tap(find.text('Albania'));
      expect(fired, [_selection]);

      fired.clear();
      await tester.tap(find.byIcon(UntitledUI.heart_filled));
      expect(fired, [_selection]);
    });

    testWidgets('ExpandableIpCard child item fires exactly once', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        ExpandableIpCard(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          initiallyExpanded: true,
          items: [IpCardItem(name: 'Child A', subtitle: '1.1.1.1', onTap: () {})],
        ),
      );

      await tester.tap(find.text('Child A'));

      expect(fired, [_selection]);
    });

    testWidgets('CheckboxItem', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        CheckboxItem(value: false, onChanged: () {}, label: const Text('Agree')),
        wrapInScaffold: true,
      );

      await tester.tap(find.text('Agree'));

      expect(fired, [_selection]);
    });

    testWidgets('RadioButton', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, RadioButton<int>(value: 1, onPressed: () {}));

      await tester.tap(find.byType(RadioButton<int>));

      expect(fired, [_selection]);
    });

    testWidgets('MainIpCard favourite fires exactly once', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, _mainIpCard(status: _connected, onFavorite: () {}));

      await tester.tap(find.byIcon(UntitledUI.heart));

      expect(fired, [_selection]);
    });
  });

  group('A consequential commit fires impact', () {
    testWidgets('connect', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        _mainIpCard(status: const MainIpCardNotConnected(), onConnect: () {}),
      );

      await tester.tap(find.text('Connect'));

      expect(fired, [_impact]);
    });

    testWidgets('disconnect', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, _mainIpCard(status: _connected, onDisconnect: () {}));

      await tester.tap(find.text('Disconnect'));

      expect(fired, [_impact]);
    });
  });

  group('Moving the view stays silent', () {
    testWidgets('BottomNavBar', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        BottomNavBar(items: _navItems, selectedIndex: 0, onDestinationSelected: (_) {}),
      );

      await tester.tap(find.text('Settings'));

      expect(fired, isEmpty);
    });

    testWidgets('NavRail', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        NavRail(
          currentIndex: 0,
          items: [
            const NavRailItem(icon: UntitledUI.map_01, label: 'Map'),
            NavRailItem(icon: UntitledUI.settings_01, label: 'Settings', onTap: () {}),
          ],
        ),
      );

      await tester.tap(find.byIcon(UntitledUI.settings_01));

      expect(fired, isEmpty);
    });

    testWidgets('NavItem', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, NavItem(icon: const Icon(Icons.home), label: 'Home', onTap: () {}));

      await tester.tap(find.text('Home'));

      expect(fired, isEmpty);
    });

    testWidgets('IntentTab', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, IntentTab(icon: Icons.speed, label: 'Fast', onTap: () {}));

      await tester.tap(find.text('Fast'));

      expect(fired, isEmpty);
    });

    testWidgets('NewsTab', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, NewsTab(icon: UntitledUI.file_06, label: 'News', onTap: () {}));

      await tester.tap(find.text('News'));

      expect(fired, isEmpty);
    });

    testWidgets('SettingsCard row', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, SettingsCard(title: 'Account', onTap: () {}));

      await tester.tap(find.text('Account'));

      expect(fired, isEmpty);
    });

    testWidgets('ExpandableIpCard chevron', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        const ExpandableIpCard(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          items: [IpCardItem(name: 'Child A', subtitle: '1.1.1.1')],
        ),
      );

      await tester.tap(find.byIcon(UntitledUI.chevron_down));

      expect(fired, isEmpty);
    });

    testWidgets('MainIpCard details chevron', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, _mainIpCard(status: _connected, onDetails: () {}));

      await tester.tap(find.byIcon(UntitledUI.chevron_right));

      expect(fired, isEmpty);
    });

    testWidgets('RefreshIconButton', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, RefreshIconButton(onPressed: () {}));

      await tester.tap(find.byType(IconButton));

      expect(fired, isEmpty);
    });

    testWidgets('FloatingButton', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, FloatingButton(label: 'Skip', icon: Icons.close, onPressed: () {}));

      await tester.tap(find.text('Skip'));

      expect(fired, isEmpty);
    });

    testWidgets('PlanCard action footer', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        PlanCard<int>.actions(
          data: _offerData,
          onPressed: () {},
          text: 'Buy',
          value: 1,
          mode: PlanCardMode.normal,
        ),
      );

      await tester.tap(find.text('Buy'));

      expect(fired, isEmpty);
    });

    testWidgets('PlanCard features toggle', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        PlanCard<int>.features(
          data: _offerData,
          features: const ['One', 'Two', 'Three', 'Four', 'Five'],
          viewMoreLabel: 'View more',
          viewLessLabel: 'View less',
          value: 1,
          mode: PlanCardMode.normal,
        ),
        screenType: ScreenType.desktop,
      );

      await tester.tap(find.text('View more'));

      expect(fired, isEmpty);
    });
  });
}
