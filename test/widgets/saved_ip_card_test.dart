import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

Widget _card({
  SavedIpCardType type = SavedIpCardType.favorite,
  SavedIpCardStatus status = SavedIpCardStatus.idle,
  bool isFavorite = true,
  VoidCallback? onTap,
  VoidCallback? onFavoriteTap,
}) => SavedIpCard(
  countryIcon: const ColoredBox(color: Colors.red),
  name: 'Albania',
  subtitle: 'Tirana',
  ipAddress: '195.285.15.404',
  badgeLabel: 'Residential IP',
  type: type,
  status: status,
  isFavorite: isFavorite,
  onTap: onTap,
  onFavoriteTap: onFavoriteTap,
);

/// The background colour of the card's surface [DecoratedBox].
Color? _surfaceColor(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find.descendant(of: find.byType(SavedIpCard), matching: find.byType(DecoratedBox)).first,
  );
  return (box.decoration as BoxDecoration).color;
}

/// The badge pill's decoration — the only [DecoratedBox] in the card with a
/// border.
BoxDecoration _badgeDecoration(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(of: find.byType(SavedIpCard), matching: find.byType(DecoratedBox)),
    )
    .map((it) => it.decoration as BoxDecoration)
    .firstWhere((it) => it.border != null);

void main() {
  group('SavedIpCard', () {
    testWidgets('renders name, subtitle, IP address and badge label', (tester) async {
      await pumpWidget(tester, _card());
      expect(find.text('Albania'), findsOneWidget);
      expect(find.text('Tirana'), findsOneWidget);
      expect(find.text('195.285.15.404'), findsOneWidget);
      expect(find.text('Residential IP'), findsOneWidget);
    });

    testWidgets('favourite type shows the filled heart icon', (tester) async {
      await pumpWidget(tester, _card());
      expect(find.byIcon(UntitledUI.heart_filled), findsOneWidget);
      expect(find.byIcon(UntitledUI.lock_01), findsNothing);
    });

    testWidgets('shows an outline heart when isFavorite is false', (tester) async {
      await pumpWidget(tester, _card(isFavorite: false));
      expect(find.byIcon(UntitledUI.heart), findsOneWidget);
      expect(find.byIcon(UntitledUI.heart_filled), findsNothing);
    });

    testWidgets('announces the heart with the caller-supplied semantic label', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpWidget(
        tester,
        SavedIpCard(
          countryIcon: const ColoredBox(color: Colors.red),
          name: 'Albania',
          subtitle: 'Tirana',
          ipAddress: '195.285.15.404',
          badgeLabel: 'Residential IP',
          favoriteSemanticLabel: 'Remove from favourites',
          onFavoriteTap: () {},
        ),
      );
      expect(find.bySemanticsLabel('Remove from favourites'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('tapping the outline heart calls onFavoriteTap', (tester) async {
      var heartTapped = false;
      await pumpWidget(tester, _card(isFavorite: false, onFavoriteTap: () => heartTapped = true));
      await tester.tap(find.byIcon(UntitledUI.heart));
      expect(heartTapped, isTrue);
    });

    testWidgets('locked type shows the lock icon', (tester) async {
      await pumpWidget(tester, _card(type: SavedIpCardType.locked));
      expect(find.byIcon(UntitledUI.lock_01), findsOneWidget);
      expect(find.byIcon(UntitledUI.heart_filled), findsNothing);
    });

    testWidgets('tapping the card calls onTap', (tester) async {
      var tapped = false;
      await pumpWidget(tester, _card(onTap: () => tapped = true));
      await tester.tap(find.text('Albania'));
      expect(tapped, isTrue);
    });

    testWidgets('tapping the heart calls onFavoriteTap, not onTap', (tester) async {
      var cardTapped = false;
      var heartTapped = false;
      await pumpWidget(
        tester,
        _card(onTap: () => cardTapped = true, onFavoriteTap: () => heartTapped = true),
      );
      await tester.tap(find.byIcon(UntitledUI.heart_filled));
      expect(heartTapped, isTrue);
      expect(cardTapped, isFalse);
    });

    testWidgets('disabled card ignores taps and uses the disabled surface', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        _card(
          type: SavedIpCardType.locked,
          status: SavedIpCardStatus.disabled,
          onTap: () => tapped = true,
        ),
      );
      await tester.tap(find.text('Albania'));
      expect(tapped, isFalse);
      expect(_surfaceColor(tester), DesignSystem.lightTheme.palette.bgSecondaryDisabled);
    });

    testWidgets('disabled favourite card still allows removal via the heart', (tester) async {
      var cardTapped = false;
      var heartTapped = false;
      await pumpWidget(
        tester,
        _card(
          status: SavedIpCardStatus.disabled,
          onTap: () => cardTapped = true,
          onFavoriteTap: () => heartTapped = true,
        ),
      );

      await tester.tap(find.byIcon(UntitledUI.heart_filled));
      expect(heartTapped, isTrue, reason: 'an unusable saved IP must still be removable');

      await tester.tap(find.text('Albania'));
      expect(cardTapped, isFalse, reason: 'the card itself stays non-interactive');
    });

    testWidgets('disabled card mutes the text colors', (tester) async {
      await pumpWidget(
        tester,
        _card(type: SavedIpCardType.locked, status: SavedIpCardStatus.disabled),
      );
      final palette = DesignSystem.lightTheme.palette;
      final name = tester.widget<Text>(find.text('Albania'));
      expect(name.style?.color, palette.textPrimaryDisabled);
    });

    // Figma disabled tokens: bg-secondary_disabled, text/icon-primary_disabled.
    for (final (label, isDark, bg, fg) in const [
      ('light', false, Color(0xFFE9EAEB), Color(0xFFA4A7AE)),
      ('dark', true, Color(0xFF544A78), Color(0xFFBFB9D4)),
    ]) {
      testWidgets('unavailable card matches the Figma disabled tokens ($label)', (tester) async {
        await pumpWidget(
          tester,
          _card(status: SavedIpCardStatus.disabled),
          theme: isDark ? DesignSystem.darkTheme : DesignSystem.lightTheme,
        );
        expect(_surfaceColor(tester), bg);
        expect(tester.widget<Text>(find.text('Albania')).style?.color, fg);
        expect(tester.widget<Text>(find.text('Tirana')).style?.color, fg);
        expect(tester.widget<Text>(find.text('195.285.15.404')).style?.color, fg);
        expect(tester.widget<Icon>(find.byIcon(UntitledUI.heart_filled)).color, fg);
      });
    }

    // NOTE: resolve the theme inside the test body — building a DesignSystem
    // theme at collection time triggers a GoogleFonts fetch outside a test zone.
    for (final isDark in [false, true]) {
      testWidgets('the badge keeps its border when unavailable (${isDark ? 'dark' : 'light'})', (
        tester,
      ) async {
        final theme = isDark ? DesignSystem.darkTheme : DesignSystem.lightTheme;

        await pumpWidget(tester, _card(), theme: theme);
        expect((_badgeDecoration(tester).border! as Border).top.color, theme.palette.borderPrimary);

        await pumpWidget(tester, _card(status: SavedIpCardStatus.disabled), theme: theme);
        expect(
          (_badgeDecoration(tester).border! as Border).top.color,
          theme.palette.borderPrimary,
          reason: 'unavailable badge uses the same border token as an available one',
        );
      });
    }

    // Figma: the pill on a connected row is bg-secondary_CTA (#FFFFFF29 in
    // dark), i.e. a translucent layer over the row — not the page background,
    // which reads as a hole punched in the row.
    for (final isDark in [false, true]) {
      testWidgets('connected pill uses the CTA surface (${isDark ? 'dark' : 'light'})', (
        tester,
      ) async {
        final theme = isDark ? DesignSystem.darkTheme : DesignSystem.lightTheme;
        await pumpWidget(tester, _card(status: SavedIpCardStatus.connected), theme: theme);

        expect(_badgeDecoration(tester).color, theme.palette.bgSecondarySelectedCta);
      });
    }

    test('dark bgSecondarySelectedCta is the translucent Figma layer', () {
      expect(DesignSystem.darkTheme.palette.bgSecondarySelectedCta, const Color(0x29FFFFFF));
    });

    test('dark borderPrimary is translucent so it shows on any surface', () {
      // Figma `border-primary` (dark) = #FFFFFF29.
      expect(DesignSystem.darkTheme.palette.borderPrimary, const Color(0x29FFFFFF));
    });

    testWidgets('idle card uses the primary surface', (tester) async {
      await pumpWidget(tester, _card());
      expect(_surfaceColor(tester), DesignSystem.lightTheme.palette.bgPrimary);
    });

    testWidgets('connected card uses the selected surface and stays tappable', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        _card(status: SavedIpCardStatus.connected, onTap: () => tapped = true),
      );
      expect(_surfaceColor(tester), DesignSystem.lightTheme.palette.bgSecondarySelected);
      await tester.tap(find.text('Albania'));
      expect(tapped, isTrue);
    });

    testWidgets('hovering a connected card paints the selected hover surface', (tester) async {
      await pumpWidget(tester, _card(status: SavedIpCardStatus.connected, onTap: () {}));
      final palette = DesignSystem.lightTheme.palette;
      expect(_surfaceColor(tester), palette.bgSecondarySelected);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(SavedIpCard)));
      await tester.pump();
      expect(_surfaceColor(tester), palette.bgSecondarySelectedHover);
    });

    for (final status in [SavedIpCardStatus.idle, SavedIpCardStatus.disabled]) {
      testWidgets('the heart paints a hover overlay when ${status.name}', (tester) async {
        await pumpWidget(tester, _card(status: status, onFavoriteTap: () {}));

        BoxDecoration heartDecoration() =>
            tester
                    .widget<Container>(
                      find.descendant(
                        of: find.byType(SavedIpCard),
                        matching: find.byType(Container),
                      ),
                    )
                    .decoration!
                as BoxDecoration;

        expect(heartDecoration().color, isNull, reason: 'no overlay at rest');
        expect(heartDecoration().shape, BoxShape.circle);

        final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(find.byIcon(UntitledUI.heart_filled)));
        await tester.pump();
        expect(
          heartDecoration().color,
          isNotNull,
          reason: 'hovering the heart must paint an overlay',
        );
      });
    }

    testWidgets('hovering an idle card paints the hover surface', (tester) async {
      await pumpWidget(tester, _card(onTap: () {}));
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(SavedIpCard)));
      await tester.pump();
      expect(_surfaceColor(tester), DesignSystem.lightTheme.palette.bgPrimaryHover);
    });

    testWidgets('renders on the dark theme', (tester) async {
      await pumpWidget(tester, _card(), theme: DesignSystem.darkTheme);
      expect(find.text('Albania'), findsOneWidget);
      expect(find.byIcon(UntitledUI.heart_filled), findsOneWidget);
      expect(_surfaceColor(tester), DesignSystem.darkTheme.palette.bgPrimary);
    });
  });
}
