import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/decoration.dart';
import '../helpers/hover.dart';
import '../helpers/pump_widget.dart';

/// Resting background of an interactive row — painted by the Material so the
/// ink lands above it.
Color? _rowColor(WidgetTester tester) => tester
    .widget<Material>(
      find.descendant(of: find.byType(GroupedCardShell), matching: find.byType(Material)).first,
    )
    .color;

/// Resting background of a read-only row, which carries no Material.
Color? _plainRowColor(WidgetTester tester) =>
    decorationOf(tester, find.byType(GroupedCardShell)).color;

Finder _rowInk() =>
    find.descendant(of: find.byType(GroupedCardShell), matching: find.byType(InkWell));

/// The overlay the row paints for [state].
Color? _overlay(WidgetTester tester, WidgetState state) =>
    tester.widget<InkWell>(_rowInk()).overlayColor?.resolve({state});

void main() {
  group('SettingsCard', () {
    testWidgets('renders title', (tester) async {
      await pumpWidget(tester, const SettingsCard(title: 'Account'));
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('renders icon and subtitle', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Account',
          icon: Icon(Icons.person),
          subtitle: 'user@example.com',
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('renders subtitleWidget instead of subtitle string', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Link',
          subtitle: 'should be hidden',
          subtitleWidget: Text('Custom Widget'),
        ),
      );
      expect(find.text('Custom Widget'), findsOneWidget);
      expect(find.text('should be hidden'), findsNothing);
    });

    testWidgets('renders trailing widget', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(title: 'Theme', trailing: Icon(Icons.chevron_right)),
      );
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('all positions render without error', (tester) async {
      for (final position in SettingsCardPosition.values) {
        await pumpWidget(tester, SettingsCard(title: 'Card', position: position));
        expect(find.text('Card'), findsOneWidget);
      }
    });

    testWidgets('adapts styling for desktop', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(title: 'Desktop Card'),
        screenType: ScreenType.desktop,
      );
      expect(find.text('Desktop Card'), findsOneWidget);
    });

    testWidgets('does not render badge when badgeText is null', (tester) async {
      await pumpWidget(tester, const SettingsCard(title: 'Account'));
      expect(find.byType(AppBadge), findsNothing);
    });

    testWidgets('renders badge beside title when badgeText is set', (tester) async {
      await pumpWidget(tester, const SettingsCard(title: 'Kill switch', badgeText: 'Beta'));
      expect(find.byType(AppBadge), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      final badge = tester.widget<AppBadge>(find.byType(AppBadge));
      expect(badge.type, BadgeType.neutral);
      expect(badge.size, BadgeSize.small);
    });

    testWidgets('forwards badgeType to AppBadge', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Kill switch',
          badgeText: 'Warning',
          badgeType: BadgeType.warning,
        ),
      );
      final badge = tester.widget<AppBadge>(find.byType(AppBadge));
      expect(badge.type, BadgeType.warning);
      expect(find.text('Warning'), findsOneWidget);
    });

    testWidgets('renders badge in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(title: 'Reset app', badgeText: 'New', badgeType: BadgeType.error),
        theme: DesignSystem.darkTheme,
      );
      expect(find.byType(AppBadge), findsOneWidget);
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('does not render footer when null', (tester) async {
      await pumpWidget(tester, const SettingsCard(title: 'Account'));
      expect(find.byKey(const Key('settings-card-footer')), findsNothing);
    });

    testWidgets('renders footer when provided', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Kill switch',
          footer: Text('Footer content', key: Key('settings-card-footer')),
        ),
      );
      expect(find.text('Kill switch'), findsOneWidget);
      expect(find.byKey(const Key('settings-card-footer')), findsOneWidget);
      expect(find.text('Footer content'), findsOneWidget);
    });

    testWidgets('renders footer together with trailing', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Theme',
          trailing: Icon(Icons.chevron_right),
          footer: Text('Footer content', key: Key('settings-card-footer')),
        ),
      );
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      expect(find.byKey(const Key('settings-card-footer')), findsOneWidget);
    });

    testWidgets('renders footer in dark theme', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Kill switch',
          footer: Text('Footer content', key: Key('settings-card-footer')),
        ),
        theme: DesignSystem.darkTheme,
      );
      expect(find.byKey(const Key('settings-card-footer')), findsOneWidget);
      expect(find.text('Footer content'), findsOneWidget);
    });
    testWidgets('calls onTap when the row is tapped', (tester) async {
      var tapped = false;
      await pumpWidget(tester, SettingsCard(title: 'Account', onTap: () => tapped = true));

      await tester.tap(find.text('Account'));

      expect(tapped, isTrue);
    });

    testWidgets('tappable row overlays bgPrimaryHover for hover, press and focus', (tester) async {
      await pumpWidget(tester, SettingsCard(title: 'Account', onTap: () {}));
      final palette = DesignSystem.lightTheme.palette;

      expect(_rowColor(tester), palette.bgPrimary);
      expect(_overlay(tester, WidgetState.hovered), palette.bgPrimaryHover);
      expect(_overlay(tester, WidgetState.pressed), palette.bgPrimaryHover);
      expect(_overlay(tester, WidgetState.focused), palette.bgPrimaryHover);
    });

    testWidgets("ink is clipped to each position's corner rounding", (tester) async {
      const expected = {
        SettingsCardPosition.single: BorderRadius.all(Radius.kS),
        SettingsCardPosition.top: BorderRadius.vertical(top: Radius.kS),
        SettingsCardPosition.middle: BorderRadius.zero,
        SettingsCardPosition.bottom: BorderRadius.vertical(bottom: Radius.kS),
      };

      for (final entry in expected.entries) {
        await pumpWidget(tester, SettingsCard(title: 'Account', position: entry.key, onTap: () {}));
        expect(
          tester.widget<InkWell>(_rowInk()).borderRadius,
          entry.value,
          reason: 'splash must not escape the ${entry.key.name} row',
        );
      }
    });

    testWidgets('a press completes without leaving the row stuck', (tester) async {
      var taps = 0;
      await pumpWidget(tester, SettingsCard(title: 'Account', onTap: () => taps++));

      final gesture = await tester.startGesture(tester.getCenter(find.text('Account')));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(taps, 1);
      expect(_rowColor(tester), DesignSystem.lightTheme.palette.bgPrimary);
    });

    testWidgets('transparent desktop row keeps the panel surface', (tester) async {
      await pumpWidget(
        tester,
        SettingsCard(title: 'Account', onTap: () {}),
        screenType: ScreenType.desktop,
      );

      expect(_rowColor(tester), Palette.transparent);
      expect(_overlay(tester, WidgetState.hovered), DesignSystem.lightTheme.palette.bgPrimaryHover);
    });

    testWidgets('tappable row uses the dark palette tokens', (tester) async {
      await pumpWidget(
        tester,
        SettingsCard(title: 'Account', onTap: () {}),
        theme: DesignSystem.darkTheme,
      );
      final palette = DesignSystem.darkTheme.palette;

      expect(_rowColor(tester), palette.bgPrimary);
      expect(_overlay(tester, WidgetState.hovered), palette.bgPrimaryHover);
    });

    testWidgets('row without onTap builds no ink and stays inert', (tester) async {
      await pumpWidget(tester, const SettingsCard(title: 'Account'));

      expect(_rowInk(), findsNothing);
      expect(
        find.descendant(of: find.byType(GroupedCardShell), matching: find.byType(Material)),
        findsNothing,
      );

      await hover(tester, find.text('Account'));

      expect(_plainRowColor(tester), DesignSystem.lightTheme.palette.bgPrimary);
    });
  });
}
