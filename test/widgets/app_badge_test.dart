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

    testWidgets('warning type uses warning palette colours', (tester) async {
      await pumpWidget(tester, const AppBadge(text: 'Soon', type: BadgeType.warning));
      final palette = DesignSystem.lightTheme.palette;
      final decoration = _badgeDecoration(tester);
      expect(decoration.color, palette.bgWarning);
      expect(decoration.border?.top.color, Palette.warning.shade400);

      final text = tester.widget<Text>(find.text('Soon'));
      expect(text.style?.color, palette.textWarningPrimary);
    });

    testWidgets('error type uses error palette colours', (tester) async {
      await pumpWidget(tester, const AppBadge(text: 'Failed', type: BadgeType.error));
      final palette = DesignSystem.lightTheme.palette;
      final decoration = _badgeDecoration(tester);
      expect(decoration.color, palette.bgError);
      expect(decoration.border?.top.color, Palette.error.shade400);

      final text = tester.widget<Text>(find.text('Failed'));
      expect(text.style?.color, palette.textErrorPrimary);
    });

    testWidgets('renders warning and error in dark theme', (tester) async {
      for (final type in [BadgeType.warning, BadgeType.error]) {
        await pumpWidget(
          tester,
          AppBadge(text: type.name, type: type),
          theme: DesignSystem.darkTheme,
        );
        expect(find.text(type.name), findsOneWidget);
      }
    });
  });
}
