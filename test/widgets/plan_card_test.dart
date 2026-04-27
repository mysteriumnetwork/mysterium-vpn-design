import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _data = PlanData(
  name: '1-year plan',
  fullPriceLabel: 'Total',
  fullPrice: r'$99',
  periodLabel: '/year',
  perMonth: '/mo',
  promoBadge: 'Popular',
);

const _offerData = PlanData(
  name: 'Offer',
  fullPriceLabel: 'Total',
  fullPrice: r'$49',
  periodLabel: '/year',
  perMonth: '/mo',
  promoBadge: '50% OFF',
  isOffer: true,
);

void main() {
  group('PlanCard', () {
    testWidgets('features factory renders each feature row', (tester) async {
      await pumpWidget(
        tester,
        PlanCard<int>.features(
          data: _data,
          features: const ['Unlimited bandwidth', 'No logs'],
          viewMoreLabel: 'View more',
          viewLessLabel: 'View less',
          value: 1,
          mode: PlanCardMode.normal,
        ),
      );
      expect(find.text('Unlimited bandwidth'), findsOneWidget);
      expect(find.text('No logs'), findsOneWidget);
    });

    testWidgets('actions factory fires onPressed when tapped', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        PlanCard<int>.actions(
          data: _data,
          onPressed: () => tapped = true,
          text: 'Choose',
          mode: PlanCardMode.normal,
        ),
      );
      await tester.tap(find.text('Choose'));
      expect(tapped, isTrue);
    });

    testWidgets('selectable mode updates group on tap', (tester) async {
      int? selected;
      await pumpWidget(
        tester,
        RadioGroup<int>(
          onChanged: (v) => selected = v,
          child: const PlanCard<int>(data: _data, value: 1),
        ),
      );
      await tester.tap(find.text('1-year plan'));
      expect(selected, equals(1));
    });

    testWidgets('highlight mode renders without a RadioGroup', (tester) async {
      await pumpWidget(tester, const PlanCard<int>(data: _data, mode: PlanCardMode.highlight));
      expect(find.text('1-year plan'), findsOneWidget);
    });

    testWidgets('normal mode is non-interactive', (tester) async {
      int? selected;
      await pumpWidget(
        tester,
        RadioGroup<int>(
          onChanged: (v) => selected = v,
          child: const PlanCard<int>(data: _data, value: 1, mode: PlanCardMode.normal),
        ),
      );
      await tester.tap(find.text('1-year plan'));
      expect(selected, isNull);
    });

    testWidgets('offer layout hides the name row', (tester) async {
      await pumpWidget(tester, const PlanCard<int>(data: _offerData, mode: PlanCardMode.normal));
      expect(find.text('Offer'), findsNothing);
      expect(find.text('50% OFF'), findsOneWidget);
    });
  });
}
