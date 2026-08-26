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
