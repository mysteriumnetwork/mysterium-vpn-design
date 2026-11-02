import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/haptics.dart';
import '../helpers/pump_widget.dart';

const _selection = 'HapticFeedbackType.selectionClick';
const _press = 'HapticFeedbackType.lightImpact';
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

void main() {
  group('Button haptics', () {
    testWidgets('primary fires a single press haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, ButtonPrimary(onPressed: () {}, child: const Text('Go')));

      await tester.tap(find.text('Go'));

      expect(fired, [_press]);
    });

    testWidgets('secondary and tertiary fire a press haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        Column(
          children: [
            ButtonSecondary(onPressed: () {}, child: const Text('Two')),
            ButtonTertiary(onPressed: () {}, child: const Text('Three')),
          ],
        ),
      );

      await tester.tap(find.text('Two'));
      await tester.tap(find.text('Three'));

      expect(fired, [_press, _press]);
    });

    testWidgets('haptic override escalates to impact', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        ButtonPrimary(onPressed: () {}, haptic: HapticLevel.impact, child: const Text('Connect')),
      );

      await tester.tap(find.text('Connect'));

      expect(fired, [_impact]);
    });

    testWidgets('none stays silent but still invokes onPressed', (tester) async {
      final fired = recordHaptics(tester);
      var pressed = false;
      await pumpWidget(
        tester,
        ButtonPrimary(
          onPressed: () => pressed = true,
          haptic: HapticLevel.none,
          child: const Text('Quiet'),
        ),
      );

      await tester.tap(find.text('Quiet'));

      expect(pressed, isTrue);
      expect(fired, isEmpty);
    });

    testWidgets('disabled button stays silent', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, const ButtonPrimary(onPressed: null, child: Text('Off')));

      await tester.tap(find.text('Off'));

      expect(fired, isEmpty);
    });
  });

  group('Navigation haptics', () {
    testWidgets('BottomNavBar fires a single selection haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        BottomNavBar(items: _navItems, selectedIndex: 0, onDestinationSelected: (_) {}),
      );

      await tester.tap(find.text('Settings'));

      expect(fired, [_selection]);
    });

    testWidgets('NavRail fires a single selection haptic', (tester) async {
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

      expect(fired, [_selection]);
    });

    testWidgets('NavItem fires a selection haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, NavItem(icon: const Icon(Icons.home), label: 'Home', onTap: () {}));

      await tester.tap(find.text('Home'));

      expect(fired, [_selection]);
    });

    testWidgets('IntentTab fires when idle and stays silent when disabled', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, IntentTab(icon: Icons.speed, label: 'Fast', onTap: () {}));
      await tester.tap(find.text('Fast'));
      expect(fired, [_selection]);

      fired.clear();
      await pumpWidget(
        tester,
        IntentTab(icon: Icons.speed, label: 'Off', status: IntentTabStatus.disabled, onTap: () {}),
      );
      await tester.tap(find.text('Off'));
      expect(fired, isEmpty);
    });

    testWidgets('NewsTab fires a selection haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, NewsTab(icon: UntitledUI.file_06, label: 'News', onTap: () {}));

      await tester.tap(find.text('News'));

      expect(fired, [_selection]);
    });
  });

  group('Selection surface haptics', () {
    testWidgets('LocationCard fires a selection haptic', (tester) async {
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

    testWidgets('SavedIpCard row selects and its heart presses', (tester) async {
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
      expect(fired, [_press]);
    });

    testWidgets('CheckboxItem fires a selection haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        CheckboxItem(value: false, onChanged: () {}, label: const Text('Agree')),
        wrapInScaffold: true,
      );

      await tester.tap(find.text('Agree'));

      expect(fired, [_selection]);
    });

    testWidgets('RadioButton fires a selection haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, RadioButton<int>(value: 1, onPressed: () {}));

      await tester.tap(find.byType(RadioButton<int>));

      expect(fired, [_selection]);
    });
  });

  group('SettingsCard haptics', () {
    // SettingsCard forwards onTap into GroupedCardShell. Wrapping both would
    // fire twice, so this asserts the exact count rather than "a haptic".
    testWidgets('fires exactly one selection haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, SettingsCard(title: 'Account', onTap: () {}));

      await tester.tap(find.text('Account'));

      expect(fired, [_selection]);
    });

    testWidgets('GroupedCardShell fires exactly one selection haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        GroupedCardShell(
          position: SettingsCardPosition.single,
          minHeight: 70,
          padding: const EdgeInsets.all(16),
          onTap: () {},
          child: const Text('Row'),
        ),
      );

      await tester.tap(find.text('Row'));

      expect(fired, [_selection]);
    });
  });

  group('ExpandableIpCard haptics', () {
    testWidgets('child item fires exactly one selection haptic', (tester) async {
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

    testWidgets('content selects and chevron presses', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        ExpandableIpCard(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          onConnect: () {},
          items: const [IpCardItem(name: 'Child A', subtitle: '1.1.1.1')],
        ),
      );

      await tester.tap(find.text('Germany'));
      expect(fired, [_selection]);

      fired.clear();
      await tester.tap(find.byIcon(UntitledUI.chevron_down));
      expect(fired, [_press]);
    });
  });

  group('MainIpCard haptics', () {
    testWidgets('connect fires an impact haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        MainIpCard(
          status: const MainIpCardNotConnected(),
          connectLabel: 'Connect',
          disconnectLabel: 'Disconnect',
          connectingLabel: 'Connecting…',
          noConnectionTitle: 'Not connected',
          noConnectionDescription: 'Pick a country',
          onConnect: () {},
        ),
      );

      await tester.tap(find.text('Connect'));

      expect(fired, [_impact]);
    });

    testWidgets('details icon fires exactly one press haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(
        tester,
        MainIpCard(
          status: const MainIpCardConnected(
            country: 'Germany',
            countryIcon: _flag,
            city: 'Frankfurt',
            ipAddress: '203.0.113.5',
          ),
          connectLabel: 'Connect',
          disconnectLabel: 'Disconnect',
          connectingLabel: 'Connecting…',
          noConnectionTitle: 'Not connected',
          noConnectionDescription: 'Pick a country',
          onDetails: () {},
        ),
      );

      await tester.tap(find.byIcon(UntitledUI.chevron_right));

      expect(fired, [_press]);
    });
  });

  group('Raw button haptics', () {
    testWidgets('FloatingButton fires a press haptic', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, FloatingButton(label: 'Skip', icon: Icons.close, onPressed: () {}));

      await tester.tap(find.text('Skip'));

      expect(fired, [_press]);
    });

    testWidgets('RefreshIconButton fires, and stays silent while spinning', (tester) async {
      final fired = recordHaptics(tester);
      await pumpWidget(tester, RefreshIconButton(onPressed: () {}));
      await tester.tap(find.byType(IconButton));
      expect(fired, [_press]);

      fired.clear();
      await pumpWidget(tester, RefreshIconButton(spinning: true, onPressed: () {}));
      await tester.tap(find.byType(IconButton));
      expect(fired, isEmpty);
    });
  });

  group('PlanCard haptics', () {
    testWidgets('action footer fires exactly one press haptic', (tester) async {
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

      expect(fired, [_press]);
    });

    // The toggle only renders for an offer, on tablet+, with >3 features.
    testWidgets('features toggle fires a press haptic', (tester) async {
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

      expect(fired, [_press]);
    });
  });
}
