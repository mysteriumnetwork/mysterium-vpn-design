import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

Future<void> _open(
  WidgetTester tester, {
  required WidgetBuilder builder,
  ScreenType screenType = ScreenType.mobile,
}) async {
  late BuildContext capturedContext;
  await pumpWidget(
    tester,
    Builder(
      builder: (context) {
        capturedContext = context;
        return const Text('Home');
      },
    ),
    screenType: screenType,
  );
  showBottomSheetDialog<void>(capturedContext, builder: builder, screenType: screenType);
  await tester.pumpAndSettle();
}

void main() {
  group('BottomSheetDialog (mobile)', () {
    testWidgets('renders title, body, and primary/secondary buttons', (tester) async {
      await _open(
        tester,
        builder: (ctx) => BottomSheetDialog(
          title: 'Why?',
          body: const Text('Tell us more.'),
          primaryButton: ButtonPrimary(onPressed: () {}, child: const Text('Submit')),
          secondaryButton: ButtonSecondary(onPressed: () {}, child: const Text('Cancel')),
        ),
      );
      expect(find.text('Why?'), findsOneWidget);
      expect(find.text('Tell us more.'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('renders a back IconButton', (tester) async {
      await _open(
        tester,
        builder: (_) => const BottomSheetDialog(title: 'Hi', body: Text('Body')),
      );
      expect(find.byType(IconButton), findsWidgets);
    });
  });

  group('BottomSheetDialog (desktop)', () {
    testWidgets('renders desktop close button', (tester) async {
      await _open(
        tester,
        screenType: ScreenType.tablet,
        builder: (_) => const BottomSheetDialog(title: 'Hi', body: Text('Body')),
      );
      expect(find.byIcon(UntitledUI.x_close), findsOneWidget);
    });
  });
}
