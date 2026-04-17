import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('SettingsCard', () {
    testWidgets('renders title', (tester) async {
      await pumpWidget(tester, const SettingsCard(title: 'Account'));
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('renders icon and subtitle', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Account',
          icon: Icon(Icons.person),
          subtitle: 'user@example.com',
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('renders subtitleWidget instead of subtitle string', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(
          title: 'Link',
          subtitle: 'should be hidden',
          subtitleWidget: Text('Custom Widget'),
        ),
      );
      expect(find.text('Custom Widget'), findsOneWidget);
      expect(find.text('should be hidden'), findsNothing);
    });

    testWidgets('renders trailing widget', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(title: 'Theme', trailing: Icon(Icons.chevron_right)),
      );
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('all positions render without error', (tester) async {
      for (final position in SettingsCardPosition.values) {
        await pumpWidget(tester, SettingsCard(title: 'Card', position: position));
        expect(find.text('Card'), findsOneWidget);
      }
    });

    testWidgets('adapts styling for desktop', (tester) async {
      await pumpWidget(
        tester,
        const SettingsCard(title: 'Desktop Card'),
        screenType: ScreenType.desktop,
      );
      expect(find.text('Desktop Card'), findsOneWidget);
    });
  });
}
