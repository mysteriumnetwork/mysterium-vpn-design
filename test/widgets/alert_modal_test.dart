import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('AlertModal', () {
    testWidgets('renders title', (tester) async {
      await pumpWidget(tester, const AlertModal(title: 'Heads up'));
      expect(find.text('Heads up'), findsOneWidget);
    });

    testWidgets('renders supporting text when provided', (tester) async {
      await pumpWidget(
        tester,
        const AlertModal(title: 'Title', supportingText: 'More details here'),
      );
      expect(find.text('More details here'), findsOneWidget);
    });

    testWidgets('omits supporting text when null', (tester) async {
      await pumpWidget(tester, const AlertModal(title: 'Title'));
      expect(find.text('More details here'), findsNothing);
    });

    testWidgets('all types render without error', (tester) async {
      for (final type in AlertModalType.values) {
        await pumpWidget(tester, AlertModal(title: type.name, type: type));
        expect(find.text(type.name), findsOneWidget);
      }
    });

    testWidgets('shows close button when onClose provided', (tester) async {
      var closed = false;
      await pumpWidget(tester, AlertModal(title: 'Title', onClose: () => closed = true));
      await tester.tap(find.byIcon(UntitledUI.x_close));
      expect(closed, isTrue);
    });

    testWidgets('hides close button when onClose is null', (tester) async {
      await pumpWidget(tester, const AlertModal(title: 'Title'));
      expect(find.byIcon(UntitledUI.x_close), findsNothing);
    });

    testWidgets('hides icon when showIcon is false', (tester) async {
      await pumpWidget(tester, const AlertModal(title: 'Title', showIcon: false));
      expect(find.byIcon(UntitledUI.check_circle), findsNothing);
    });

    testWidgets('renders the custom icon instead of the type glyph', (tester) async {
      await pumpWidget(tester, const AlertModal(title: 'Title', icon: UntitledUI.thumbs_up));
      expect(find.byIcon(UntitledUI.thumbs_up), findsOneWidget);
      // The default brand glyph is replaced.
      expect(find.byIcon(UntitledUI.check_circle), findsNothing);
    });

    testWidgets('custom icon is not shown when showIcon is false', (tester) async {
      await pumpWidget(
        tester,
        const AlertModal(title: 'Title', showIcon: false, icon: UntitledUI.thumbs_up),
      );
      expect(find.byIcon(UntitledUI.thumbs_up), findsNothing);
    });

    testWidgets('applies custom surface padding', (tester) async {
      const padding = EdgeInsets.fromLTRB(16, 40, 16, 32);
      await pumpWidget(tester, const AlertModal(title: 'Title', padding: padding));
      // Match the specific surface Padding by its value rather than relying on
      // tree order — AlertModal contains several Padding widgets (e.g. _TextBlock).
      expect(
        find.descendant(
          of: find.byType(AlertModal),
          matching: find.byWidgetPredicate((w) => w is Padding && w.padding == padding),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders primary and secondary buttons', (tester) async {
      await pumpWidget(
        tester,
        AlertModal(
          title: 'Confirm',
          primaryButton: ButtonPrimary(onPressed: () {}, child: const Text('Enable')),
          secondaryButton: ButtonSecondary(onPressed: () {}, child: const Text('Dismiss')),
        ),
      );
      expect(find.text('Enable'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
    });

    testWidgets('renders input when provided', (tester) async {
      await pumpWidget(
        tester,
        const AlertModal(
          title: 'Confirm',
          input: SizedBox(key: Key('alert-input'), height: 40),
        ),
      );
      expect(find.byKey(const Key('alert-input')), findsOneWidget);
    });

    testWidgets('renders on mobile screenType', (tester) async {
      await pumpWidget(tester, const AlertModal(title: 'Mobile', screenType: ScreenType.mobile));
      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('renders on tablet screenType', (tester) async {
      await pumpWidget(tester, const AlertModal(title: 'Desktop', screenType: ScreenType.tablet));
      expect(find.text('Desktop'), findsOneWidget);
    });
  });
}
