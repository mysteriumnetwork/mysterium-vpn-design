import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('Snackbar', () {
    testWidgets('renders message', (tester) async {
      await pumpWidget(tester, const Snackbar(message: 'Promo code copied'));
      expect(find.text('Promo code copied'), findsOneWidget);
    });

    testWidgets('all types render without error', (tester) async {
      for (final type in SnackbarType.values) {
        await pumpWidget(tester, Snackbar(message: type.name, type: type));
        expect(find.text(type.name), findsOneWidget);
      }
    });

    testWidgets('renders action when provided', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        Snackbar(
          message: 'With action',
          action: IconButton(icon: const Icon(Icons.close), onPressed: () => tapped = true),
        ),
      );
      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      expect(tapped, isTrue);
    });

    // The snackbar surface is inverted, so its action must take its brand
    // colour from the opposite theme: brand-300 on the dark surface a light
    // page shows, brand-600 on the light surface a dark page shows.
    for (final (label, isDark, expected) in const [
      ('light page', false, Color(0xFFE8AAFD)),
      ('dark page', true, Color(0xFFA924D5)),
    ]) {
      testWidgets('action resolves its colours from the inverted theme ($label)', (tester) async {
        await pumpWidget(
          tester,
          Snackbar(
            message: 'Removed',
            action: ButtonTertiary(onPressed: () {}, child: const Text('Undo')),
          ),
          theme: isDark ? DesignSystem.darkTheme : DesignSystem.lightTheme,
        );

        expect(tester.renderObject<RenderParagraph>(find.text('Undo')).text.style?.color, expected);

        // What the Snackbar hands down is the theme the action resolves from.
        final style = Theme.of(tester.element(find.byType(ButtonTertiary))).textButtonTheme.style!;
        expect(
          style.foregroundColor?.resolve({WidgetState.hovered}),
          expected,
          reason: 'hover must not darken the label into the surface',
        );
        expect(style.overlayColor?.resolve({}), isNull, reason: 'no overlay at rest');
        expect(
          style.overlayColor?.resolve({WidgetState.hovered}),
          expected.withValues(alpha: 0.16),
        );
        expect(
          style.overlayColor?.resolve({WidgetState.pressed}),
          expected.withValues(alpha: 0.24),
        );

        // Merged into the inverted theme's button style, not replacing it.
        expect(style.textStyle?.resolve({}), isNotNull);
      });
    }

    testWidgets('omits action when null', (tester) async {
      await pumpWidget(tester, const Snackbar(message: 'No action'));
      expect(find.byType(IconButton), findsNothing);
    });
  });
}
