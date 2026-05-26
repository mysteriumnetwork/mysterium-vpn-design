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

    group('currentPlanLabel', () {
      testWidgets('renders the label as a header badge', (tester) async {
        await pumpWidget(
          tester,
          const PlanCard<int>(data: _data, value: 1, currentPlanLabel: 'Your plan'),
        );
        expect(find.text('Your plan'), findsOneWidget);
      });

      testWidgets('hides the radio in selectable mode', (tester) async {
        await pumpWidget(
          tester,
          RadioGroup<int>(
            onChanged: (_) {},
            child: const PlanCard<int>(data: _data, value: 1, currentPlanLabel: 'Your plan'),
          ),
        );
        expect(find.byType(RadioButton), findsNothing);
      });

      testWidgets('hides the promoBadge in favor of the current-plan label', (tester) async {
        // _data.promoBadge is 'Popular'.
        await pumpWidget(
          tester,
          const PlanCard<int>(
            data: _data,
            value: 1,
            mode: PlanCardMode.normal,
            currentPlanLabel: 'Your plan',
          ),
        );
        expect(find.text('Your plan'), findsOneWidget);
        expect(find.text('Popular'), findsNothing);
      });

      testWidgets('does not update the RadioGroup when tapped', (tester) async {
        int? selected;
        await pumpWidget(
          tester,
          RadioGroup<int>(
            onChanged: (v) => selected = v,
            child: const PlanCard<int>(data: _data, value: 1, currentPlanLabel: 'Your plan'),
          ),
        );
        await tester.tap(find.text('1-year plan'));
        await tester.pump();
        expect(selected, isNull);
      });

      testWidgets('suppresses the selected highlight even when value matches group', (
        tester,
      ) async {
        await pumpWidget(
          tester,
          RadioGroup<int>(
            onChanged: (_) {},
            groupValue: 1,
            child: const PlanCard<int>(data: _data, value: 1, currentPlanLabel: 'Your plan'),
          ),
        );
        final btn = tester.widget<RawMaterialButton>(find.byType(RawMaterialButton));
        final shape = btn.shape as RoundedRectangleBorder;
        // Highlighted = width 3, brand border. Suppressed = width 1.
        expect(shape.side.width, 1);
      });

      testWidgets('highlight mode keeps its highlight even when currentPlanLabel is set', (
        tester,
      ) async {
        await pumpWidget(
          tester,
          const PlanCard<int>(
            data: _data,
            mode: PlanCardMode.highlight,
            currentPlanLabel: 'Your plan',
          ),
        );
        final btn = tester.widget<RawMaterialButton>(find.byType(RawMaterialButton));
        final shape = btn.shape as RoundedRectangleBorder;
        expect(shape.side.width, 3);
      });

      testWidgets('does not render on offer cards (header row is suppressed)', (tester) async {
        await pumpWidget(
          tester,
          const PlanCard<int>(
            data: _offerData,
            mode: PlanCardMode.normal,
            currentPlanLabel: 'Your plan',
          ),
        );
        expect(find.text('Your plan'), findsNothing);
      });
    });
  });
}
