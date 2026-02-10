import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Features', type: PlanCard)
Widget buildPlanCardFeatures(BuildContext context) {
  final (data, isSelected, mode) = _getArgs(context);

  return RadioGroup(
    onChanged: (_) {},
    groupValue: true,
    child: PlanCard.features(
      data: data,
      value: isSelected,
      mode: mode,
      features: const [
        'Unlimited bandwidth',
        'Access to all servers',
        'No logs policy',
        '24/7 customer support',
      ],
      viewMoreLabel: 'View all features',
      viewLessLabel: 'View less',
    ),
  );
}

@UseCase(name: 'Actions', type: PlanCard)
Widget buildPlanCardActions(BuildContext context) {
  final (data, isSelected, mode) = _getArgs(context);
  return RadioGroup(
    onChanged: (_) {},
    groupValue: true,
    child: PlanCard.actions(
      data: data,
      value: isSelected,
      mode: mode,
      onPressed: () {},
      text: 'Choose Plan',
    ),
  );
}

(PlanData, bool, PlanCardMode) _getArgs(BuildContext context) {
  final data = PlanData(
    name: context.knobs.string(label: 'Plan Name', initialValue: 'Plus'),
    fullPriceLabel: context.knobs.string(label: 'Full Price Label', initialValue: 'Yearly'),
    fullPrice: context.knobs.string(label: 'Full Price', initialValue: r'$119.88'),
    discountedLabel: context.knobs.stringOrNull(label: 'Discounted Label', initialValue: 'Monthly'),
    monthlyFullPrice: context.knobs.stringOrNull(
      label: 'Monthly Full Price',
      initialValue: r'$14.99',
    ),
    monthlyDiscountedPrice: context.knobs.stringOrNull(
      label: 'Monthly Discounted Price',
      initialValue: r'$9.99',
    ),
    bestValueBadge: context.knobs.stringOrNull(label: 'Best value', initialValue: 'Best Value'),
    promoBadge: context.knobs.stringOrNull(label: 'Promo Badge', initialValue: '20% OFF'),
    isOffer: context.knobs.boolean(label: 'Is Offer'),
    periodLabel: context.knobs.string(label: 'Period Label', initialValue: 'year'),
    perMonth: context.knobs.string(label: 'Per Month', initialValue: 'mo'),
  );

  final isSelected = context.knobs.boolean(label: 'Is Selected');
  final mode = context.knobs.object.dropdown(
    label: 'Mode',
    options: PlanCardMode.values,
    labelBuilder: (mode) => mode.name,
  );

  return (data, isSelected, mode);
}
