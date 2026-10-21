import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/hover.dart';
import '../helpers/pump_widget.dart';

Future<void> _pump(WidgetTester tester, {required VoidCallback onTap, ThemeData? theme}) =>
    pumpWidget(
      tester,
      LinkText(
        builder: (link) => [
          const TextSpan(text: 'By continuing you agree to our '),
          link('Terms', onTap),
          const TextSpan(text: '.'),
        ],
      ),
      theme: theme,
    );

/// The link's span, found by its text inside the rendered paragraph.
TextSpan _linkSpan(WidgetTester tester) {
  final root = tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
  return root.children!.whereType<TextSpan>().firstWhere((s) => s.text == 'Terms');
}

/// Centre of the link's glyphs, for hovering a span rather than a widget.
Offset _linkCentre(WidgetTester tester) {
  final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));
  final box = paragraph
      .getBoxesForSelection(const TextSelection(baseOffset: 31, extentOffset: 36))
      .first;
  return tester.getTopLeft(find.byType(RichText)) + Offset(box.left + 2, box.top + box.bottom) / 2;
}

void main() {
  group('LinkText', () {
    testWidgets('renders the whole paragraph', (tester) async {
      await _pump(tester, onTap: () {});

      expect(find.textContaining('By continuing you agree to our'), findsOneWidget);
      expect(find.textContaining('Terms'), findsOneWidget);
    });

    testWidgets('link inherits the paragraph colour at rest', (tester) async {
      await _pump(tester, onTap: () {});

      // Unset, so the surrounding paragraph's colour shows through unchanged.
      expect(_linkSpan(tester).style?.color, isNull);
      expect(_linkSpan(tester).style?.decoration, TextDecoration.none);
    });

    testWidgets('surrounding text is not styled as a link', (tester) async {
      await _pump(tester, onTap: () {});
      final root = tester.widget<Text>(find.byType(Text)).textSpan! as TextSpan;
      final plain = root.children!.whereType<TextSpan>().firstWhere((s) => s.text == '.');

      expect(plain.style, isNull);
      expect(plain.recognizer, isNull);
    });

    testWidgets('tapping the link calls onTap', (tester) async {
      var taps = 0;
      await _pump(tester, onTap: () => taps++);

      await tester.tapAt(_linkCentre(tester));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('hover switches to the accent and adds an underline', (tester) async {
      await _pump(tester, onTap: () {});
      final palette = DesignSystem.lightTheme.palette;

      final gesture = await hover(tester, find.byType(RichText));
      await gesture.moveTo(_linkCentre(tester));
      await tester.pumpAndSettle();

      expect(_linkSpan(tester).style?.color, palette.textBrandPrimary);
      expect(_linkSpan(tester).style?.decoration, TextDecoration.underline);
    });

    testWidgets('a press switches to the accent even without hover', (tester) async {
      await _pump(tester, onTap: () {});
      final palette = DesignSystem.lightTheme.palette;

      final gesture = await tester.startGesture(_linkCentre(tester));
      await tester.pump();

      expect(_linkSpan(tester).style?.color, palette.textBrandPrimary);
      expect(_linkSpan(tester).style?.decoration, TextDecoration.underline);

      await gesture.up();
      await tester.pumpAndSettle();

      expect(_linkSpan(tester).style?.color, isNull);
    });

    testWidgets('hover clears when the pointer leaves the link', (tester) async {
      await _pump(tester, onTap: () {});

      final gesture = await hover(tester, find.byType(RichText));
      await gesture.moveTo(_linkCentre(tester));
      await tester.pumpAndSettle();

      await gesture.moveTo(tester.getBottomLeft(find.byType(RichText)) + const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(_linkSpan(tester).style?.color, isNull);
      expect(_linkSpan(tester).style?.decoration, TextDecoration.none);
    });

    testWidgets('uses the dark accent token on hover', (tester) async {
      await _pump(tester, onTap: () {}, theme: DesignSystem.darkTheme);

      expect(_linkSpan(tester).style?.color, isNull);

      final gesture = await hover(tester, find.byType(RichText));
      await gesture.moveTo(_linkCentre(tester));
      await tester.pumpAndSettle();

      expect(_linkSpan(tester).style?.color, DesignSystem.darkTheme.palette.textBrandPrimary);
    });
  });
}
