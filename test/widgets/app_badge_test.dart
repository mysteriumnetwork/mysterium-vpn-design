import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

BoxDecoration _badgeDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(of: find.byType(AppBadge), matching: find.byType(Container)),
  );
  return container.decoration! as BoxDecoration;
}

void main() {
  group('AppBadge', () {
    testWidgets('renders text', (tester) async {
      await pumpWidget(tester, const AppBadge(text: 'New'));
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('renders with each BadgeType without error', (tester) async {
      for (final type in BadgeType.values) {
        await pumpWidget(tester, AppBadge(text: type.name, type: type));
        expect(find.text(type.name), findsOneWidget);
      }
    });

    testWidgets('renders with each BadgeSize without error', (tester) async {
      for (final size in BadgeSize.values) {
        await pumpWidget(tester, AppBadge(text: 'Badge', size: size));
        expect(find.text('Badge'), findsOneWidget);
      }
    });

    testWidgets('renders a leading icon at the preset size', (tester) async {
      await pumpWidget(
        tester,
        const AppBadge(text: '+3 bonus months', icon: UntitledUI.gift_02, size: BadgeSize.small),
      );
      expect(tester.widget<Icon>(find.byIcon(UntitledUI.gift_02)).size, 12);
      expect(find.text('+3 bonus months'), findsOneWidget);

      await pumpWidget(tester, const AppBadge(text: 'Bonus', icon: UntitledUI.gift_02));
      expect(tester.widget<Icon>(find.byIcon(UntitledUI.gift_02)).size, 14);
    });

    testWidgets('an icon tightens the horizontal padding to 8', (tester) async {
      await pumpWidget(tester, const AppBadge(text: 'Bonus', icon: UntitledUI.gift_02));
      final withIcon = tester.widget<Container>(
        find.descendant(of: find.byType(AppBadge), matching: find.byType(Container)),
      );
      expect(withIcon.padding, const EdgeInsets.symmetric(horizontal: 8, vertical: 2));
    });

    testWidgets('a text-only badge keeps the 12px preset padding', (tester) async {
      await pumpWidget(tester, const AppBadge(text: 'Bonus'));
      final textOnly = tester.widget<Container>(
        find.descendant(of: find.byType(AppBadge), matching: find.byType(Container)),
      );
      expect(textOnly.padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 2));
    });

    testWidgets('an over-long label ellipsizes instead of overflowing', (tester) async {
      await pumpWidget(
        tester,
        const Center(
          child: SizedBox(
            width: 80,
            child: AppBadge(text: 'an extremely long bonus label', icon: UntitledUI.gift_02),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final text = tester.widget<Text>(find.text('an extremely long bonus label'));
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('tooltip opens on tap', (tester) async {
      await pumpWidget(
        tester,
        const AppBadge(
          text: '+3 bonus months',
          icon: UntitledUI.gift_02,
          tooltip: 'Your first subscription period includes 3 bonus months.',
        ),
      );

      expect(find.text('Your first subscription period includes 3 bonus months.'), findsNothing);

      await tester.tap(find.byType(AppBadge));
      await tester.pumpAndSettle();

      expect(find.text('Your first subscription period includes 3 bonus months.'), findsOneWidget);
    });

    testWidgets('no Tooltip is inserted when tooltip is null', (tester) async {
      await pumpWidget(tester, const AppBadge(text: 'Bonus'));
      expect(find.byType(Tooltip), findsNothing);
    });

    // Colours are asserted against the theme's own tokens, so a hardcoded
    // shade that happens to match one theme fails in the other.
    // Themes are built inside each test body: constructing them during
    // collection pulls google_fonts outside the test zone and fails the file.
    for (final label in ['light', 'dark']) {
      final isLight = label == 'light';

      testWidgets('warning type uses the $label warning tokens', (tester) async {
        final theme = isLight ? DesignSystem.lightTheme : DesignSystem.darkTheme;
        await pumpWidget(
          tester,
          const AppBadge(text: 'Soon', type: BadgeType.warning),
          theme: theme,
        );
        final palette = theme.palette;
        final decoration = _badgeDecoration(tester);
        expect(decoration.color, palette.bgWarning);
        expect(decoration.border?.top.color, palette.borderWarning);
        expect(tester.widget<Text>(find.text('Soon')).style?.color, palette.textWarningPrimary);
      });

      testWidgets('error type uses the $label error tokens', (tester) async {
        final theme = isLight ? DesignSystem.lightTheme : DesignSystem.darkTheme;
        await pumpWidget(
          tester,
          const AppBadge(text: 'Failed', type: BadgeType.error),
          theme: theme,
        );
        final palette = theme.palette;
        final decoration = _badgeDecoration(tester);
        expect(decoration.color, palette.bgError);
        expect(decoration.border?.top.color, palette.borderError);
        expect(tester.widget<Text>(find.text('Failed')).style?.color, palette.textErrorPrimary);
      });

      testWidgets('brand type uses the $label brand tokens', (tester) async {
        final theme = isLight ? DesignSystem.lightTheme : DesignSystem.darkTheme;
        await pumpWidget(
          tester,
          const AppBadge(text: 'Bonus', type: BadgeType.brand),
          theme: theme,
        );
        final palette = theme.palette;
        final decoration = _badgeDecoration(tester);
        expect(decoration.color, palette.bgBrand);
        expect(decoration.border?.top.color, palette.borderTabs);
        expect(tester.widget<Text>(find.text('Bonus')).style?.color, palette.textPrimarySelected);
      });
    }

    testWidgets('warning and error borders differ between themes', (tester) async {
      expect(
        DesignSystem.lightTheme.palette.borderWarning,
        isNot(DesignSystem.darkTheme.palette.borderWarning),
      );
      expect(
        DesignSystem.lightTheme.palette.borderError,
        isNot(DesignSystem.darkTheme.palette.borderError),
      );
    });
  });
}
