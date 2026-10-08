import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('Header', () {
    testWidgets('renders title', (tester) async {
      await pumpWidget(tester, const Header(title: Text('My Title')));
      expect(find.text('My Title'), findsOneWidget);
    });

    testWidgets('renders actions', (tester) async {
      await pumpWidget(
        tester,
        Header(
          title: const Text('Title'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.help))],
        ),
      );
      expect(find.byIcon(Icons.help), findsOneWidget);
    });

    testWidgets('shows back button when navigator can pop', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystem.lightTheme,
          home: ScreenTypeOverride(
            screenType: ScreenType.mobile,
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const Header(title: Text('Page 2'))),
                ),
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.text('Page 2'), findsOneWidget);
    });

    testWidgets('preferredSize is 64', (tester) async {
      const header = Header(title: Text('Title'));
      expect(header.preferredSize.height, 64);
    });

    testWidgets('renders on desktop screenType', (tester) async {
      await pumpWidget(tester, const Header(title: Text('Title')), screenType: ScreenType.desktop);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('renders back label as TextButton.icon when backLabel is set and title is null', (
      tester,
    ) async {
      var pressed = false;
      await pumpWidget(
        tester,
        Header(
          backLabel: 'Back to home',
          showBackButton: true,
          onBackPressed: () => pressed = true,
        ),
      );
      expect(find.text('Back to home'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      expect(pressed, isTrue);
    });

    testWidgets('renders arrow-only IconButton when backLabel is null and showBack is true', (
      tester,
    ) async {
      var pressed = false;
      await pumpWidget(tester, Header(showBackButton: true, onBackPressed: () => pressed = true));
      expect(find.byType(TextButton), findsNothing);
      expect(find.byType(IconButton), findsOneWidget);
      await tester.tap(find.byType(IconButton));
      expect(pressed, isTrue);
    });
  });

  group('Header without a Navigator ancestor', () {
    /// `MaterialApp.builder` with no `home`/`routes`: supplies Material
    /// infrastructure (localizations, Directionality, MediaQuery) while leaving
    /// the Header outside any Navigator — which is how the app mounts it on
    /// blocking screens above the router.
    Future<void> pumpBare(WidgetTester tester, Header header) => tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        builder: (context, _) => ScreenTypeOverride(
          screenType: ScreenType.mobile,
          child: Builder(
            builder: (inner) {
              // Guards the harness itself: if this ever gains a Navigator, the
              // tests below would silently stop proving anything.
              expect(Navigator.maybeOf(inner), isNull);
              return header;
            },
          ),
        ),
      ),
    );

    testWidgets('builds instead of throwing', (tester) async {
      await pumpBare(tester, Header.logo());

      expect(tester.takeException(), isNull);
      expect(find.byType(Logo), findsOneWidget);
    });

    testWidgets('shows no back control, since there is nothing to pop', (tester) async {
      await pumpBare(tester, Header.logo());

      expect(find.byType(IconButton), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('still honours an explicit showBackButton', (tester) async {
      var pressed = false;
      await pumpBare(tester, Header(showBackButton: true, onBackPressed: () => pressed = true));

      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(IconButton));
      expect(pressed, isTrue);
    });

    testWidgets('the default back action is inert rather than throwing', (tester) async {
      // No onBackPressed: the fallback runs, and it must not reach for a
      // Navigator that is not there.
      await pumpBare(tester, const Header(showBackButton: true));

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
