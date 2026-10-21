import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/decoration.dart';
import '../helpers/hover.dart';
import '../helpers/pump_widget.dart';

BoxDecoration _decoration(WidgetTester tester) => decorationOf(tester, find.byType(SearchField));

/// Pumps a field wired to a focus node the test can drive.
Future<FocusNode> _pumpFocusable(WidgetTester tester) async {
  final node = FocusNode();
  addTearDown(node.dispose);
  await pumpWidget(
    tester,
    Material(
      child: SearchField(placeholder: 'Search', focusNode: node),
    ),
  );
  return node;
}

void main() {
  group('SearchField', () {
    testWidgets('renders placeholder', (tester) async {
      await pumpWidget(
        tester,
        const Material(child: SearchField(placeholder: 'Search locations...')),
      );
      expect(find.text('Search locations...'), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? lastValue;
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', onChanged: (v) => lastValue = v),
        ),
      );
      await tester.enterText(find.byType(TextField), 'hello');
      expect(lastValue, 'hello');
    });

    testWidgets('calls onSubmitted on keyboard submit', (tester) async {
      String? submitted;
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', onSubmitted: (v) => submitted = v),
        ),
      );
      await tester.enterText(find.byType(TextField), 'query');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'query');
    });

    testWidgets('uses provided TextEditingController', (tester) async {
      final controller = TextEditingController(text: 'initial');
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', controller: controller),
        ),
      );
      expect(find.text('initial'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('TextField is enabled by default', (tester) async {
      await pumpWidget(tester, const Material(child: SearchField(placeholder: 'Search')));
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isNot(false));
    });

    testWidgets('disables the underlying TextField when enabled is false', (tester) async {
      await pumpWidget(
        tester,
        const Material(child: SearchField(placeholder: 'Search', enabled: false)),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      String? lastValue;
      await pumpWidget(
        tester,
        Material(
          child: SearchField(
            placeholder: 'Search',
            enabled: false,
            onChanged: (v) => lastValue = v,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'hello');
      expect(lastValue, isNull);
    });

    testWidgets('uses bgPrimary background when enabled', (tester) async {
      await pumpWidget(tester, const Material(child: SearchField(placeholder: 'Search')));
      expect(_decoration(tester).color, DesignSystem.lightTheme.palette.bgPrimary);
    });

    testWidgets('uses bgInactive background when disabled', (tester) async {
      await pumpWidget(
        tester,
        const Material(child: SearchField(placeholder: 'Search', enabled: false)),
      );
      expect(_decoration(tester).color, DesignSystem.lightTheme.palette.bgInactive);
    });

    testWidgets('tints to bgPrimaryHover on hover', (tester) async {
      await pumpWidget(tester, const Material(child: SearchField(placeholder: 'Search')));
      final palette = DesignSystem.lightTheme.palette;

      expect(_decoration(tester).color, palette.bgPrimary);

      final gesture = await hover(tester, find.byType(SearchField));
      expect(_decoration(tester).color, palette.bgPrimaryHover);

      // Well clear of the field, which hugs the top of the test surface.
      await gesture.moveTo(tester.getBottomLeft(find.byType(SearchField)) + const Offset(0, 100));
      await tester.pumpAndSettle();
      expect(_decoration(tester).color, palette.bgPrimary);
    });

    testWidgets('disabled field does not tint on hover', (tester) async {
      await pumpWidget(
        tester,
        const Material(child: SearchField(placeholder: 'Search', enabled: false)),
      );

      await hover(tester, find.byType(SearchField));

      expect(_decoration(tester).color, DesignSystem.lightTheme.palette.bgInactive);
    });

    testWidgets('hover state does not survive an enabled toggle', (tester) async {
      final palette = DesignSystem.lightTheme.palette;

      await pumpWidget(tester, const Material(child: SearchField(placeholder: 'Search')));
      final gesture = await hover(tester, find.byType(SearchField));
      expect(_decoration(tester).color, palette.bgPrimaryHover);

      // Disabled while the pointer is still inside.
      await pumpWidget(
        tester,
        const Material(child: SearchField(placeholder: 'Search', enabled: false)),
      );
      await tester.pumpAndSettle();
      expect(_decoration(tester).color, palette.bgInactive);

      // Pointer leaves while disabled, then the field comes back.
      await gesture.moveTo(tester.getBottomLeft(find.byType(SearchField)) + const Offset(0, 100));
      await tester.pumpAndSettle();
      await pumpWidget(tester, const Material(child: SearchField(placeholder: 'Search')));
      await tester.pumpAndSettle();

      expect(_decoration(tester).color, palette.bgPrimary);
    });

    testWidgets('hover tints with the dark palette token', (tester) async {
      await pumpWidget(
        tester,
        const Material(child: SearchField(placeholder: 'Search')),
        theme: DesignSystem.darkTheme,
      );
      final palette = DesignSystem.darkTheme.palette;

      expect(_decoration(tester).color, palette.bgPrimary);

      await hover(tester, find.byType(SearchField));

      expect(_decoration(tester).color, palette.bgPrimaryHover);
    });

    testWidgets('focus swaps the border and keeps the background flat', (tester) async {
      final node = await _pumpFocusable(tester);
      final palette = DesignSystem.lightTheme.palette;

      Color borderColor() => (_decoration(tester).border! as Border).top.color;

      expect(borderColor(), palette.borderPrimary);

      node.requestFocus();
      await tester.pumpAndSettle();

      expect(borderColor(), palette.borderBrand);
      // Focus is signalled by the border and icon, not a background shift.
      expect(_decoration(tester).color, palette.bgPrimary);
    });

    testWidgets('a focused field stays flat when hovered', (tester) async {
      final node = await _pumpFocusable(tester);

      node.requestFocus();
      await tester.pumpAndSettle();
      await hover(tester, find.byType(SearchField));

      expect(_decoration(tester).color, DesignSystem.lightTheme.palette.bgPrimary);
    });

    testWidgets('leading icon tints to borderBrand on focus', (tester) async {
      final node = await _pumpFocusable(tester);
      final palette = DesignSystem.lightTheme.palette;

      Color iconColor() => tester.widget<Icon>(find.byIcon(UntitledUI.search_sm)).color!;

      expect(iconColor(), palette.textTertiary);

      node.requestFocus();
      await tester.pumpAndSettle();

      expect(iconColor(), palette.borderBrand);
    });

    group('button mode', () {
      testWidgets('taps call onTap', (tester) async {
        var taps = 0;
        await pumpWidget(
          tester,
          Material(
            child: SearchField(placeholder: 'Search', onTap: () => taps++),
          ),
        );

        await tester.tap(find.byType(SearchField));
        await tester.pumpAndSettle();

        expect(taps, 1);
      });

      testWidgets('renders no live input to focus or type into', (tester) async {
        await pumpWidget(
          tester,
          Material(
            child: SearchField(placeholder: 'Search', onTap: () {}),
          ),
        );

        expect(find.byType(TextField), findsNothing);
        expect(find.byType(EditableText), findsNothing);
      });

      testWidgets('places the placeholder exactly where the real field does', (tester) async {
        await pumpWidget(tester, const Material(child: SearchField(placeholder: 'Search')));
        final asField = tester.getRect(find.text('Search'));

        await pumpWidget(
          tester,
          Material(
            child: SearchField(placeholder: 'Search', onTap: () {}),
          ),
        );
        final asButton = tester.getRect(find.text('Search'));

        expect(asButton, asField);
      });

      testWidgets('still tints on hover', (tester) async {
        await pumpWidget(
          tester,
          Material(
            child: SearchField(placeholder: 'Search', onTap: () {}),
          ),
        );

        await hover(tester, find.byType(SearchField));

        expect(_decoration(tester).color, DesignSystem.lightTheme.palette.bgPrimaryHover);
      });

      testWidgets('disabled button mode ignores taps', (tester) async {
        var taps = 0;
        await pumpWidget(
          tester,
          Material(
            child: SearchField(placeholder: 'Search', enabled: false, onTap: () => taps++),
          ),
        );

        await tester.tap(find.byType(SearchField));
        await tester.pumpAndSettle();

        expect(taps, 0);
      });

      testWidgets('hides the clear button even with text', (tester) async {
        final controller = TextEditingController(text: 'berlin');
        addTearDown(controller.dispose);
        await pumpWidget(
          tester,
          Material(
            child: SearchField(placeholder: 'Search', controller: controller, onTap: () {}),
          ),
        );

        expect(find.byIcon(UntitledUI.x_close), findsNothing);
      });
    });

    testWidgets('re-syncs focus border when focusNode is swapped', (tester) async {
      final nodeA = FocusNode();
      final nodeB = FocusNode();
      addTearDown(nodeA.dispose);
      addTearDown(nodeB.dispose);

      Border borderOf() => _decoration(tester).border! as Border;

      final palette = DesignSystem.lightTheme.palette;

      // Mount with nodeA and focus it — border becomes brand.
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', focusNode: nodeA),
        ),
      );
      nodeA.requestFocus();
      // Settle past the eased focus transition before reading the border.
      await tester.pumpAndSettle();
      expect(borderOf().top.color, palette.borderBrand);

      // Swap to nodeB (not focused). Bug: border stays brand because
      // _focused was never re-synced. Expected: border resets to primary.
      await pumpWidget(
        tester,
        Material(
          child: SearchField(placeholder: 'Search', focusNode: nodeB),
        ),
      );
      await tester.pumpAndSettle();
      expect(borderOf().top.color, palette.borderPrimary);
    });
  });
}
