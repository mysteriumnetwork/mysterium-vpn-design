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
    /// No MaterialApp: the app mounts a Header above the router's Navigator on
    /// its blocking screens, where `Navigator.of` would throw.
    Future<void> pumpBare(WidgetTester tester, Header header) => tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: DesignSystem.lightTheme,
            child: ScreenTypeOverride(screenType: ScreenType.mobile, child: header),
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
  });
}
