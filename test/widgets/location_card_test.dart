import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('LocationCard', () {
    testWidgets('renders name and subtitle', (tester) async {
      await pumpWidget(
        tester,
        const LocationCard(icon: Icon(Icons.flag), name: 'Germany', subtitle: 'Berlin'),
      );
      expect(find.text('Germany'), findsOneWidget);
      expect(find.text('Berlin'), findsOneWidget);
    });

    testWidgets('calls onTap when idle', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        LocationCard(
          icon: const Icon(Icons.flag),
          name: 'Germany',
          subtitle: 'Berlin',
          onTap: () => tapped = true,
        ),
      );
      await tester.tap(find.text('Germany'));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        LocationCard(
          icon: const Icon(Icons.flag),
          name: 'Germany',
          subtitle: 'Berlin',
          status: LocationCardStatus.disabled,
          onTap: () => tapped = true,
        ),
      );
      await tester.tap(find.text('Germany'));
      expect(tapped, isFalse);
    });

    testWidgets('all statuses render without error', (tester) async {
      for (final status in LocationCardStatus.values) {
        await pumpWidget(
          tester,
          LocationCard(
            icon: const Icon(Icons.flag),
            name: 'Place',
            subtitle: 'Sub',
            status: status,
          ),
        );
        expect(find.text('Place'), findsOneWidget);
      }
    });

    testWidgets('placeholder renders without icon or text', (tester) async {
      await pumpWidget(tester, const LocationCard.placeholder());
      expect(find.byIcon(Icons.flag), findsNothing);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('placeholder honors custom width', (tester) async {
      await pumpWidget(tester, const LocationCard.placeholder(width: 240));
      final sizedBox = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .firstWhere((s) => s.width == 240, orElse: () => const SizedBox());
      expect(sizedBox.width, 240);
    });
  });
}
