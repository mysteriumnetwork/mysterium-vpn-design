import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Features', type: PlanCard)
Widget buildPlanCardFeatures(BuildContext context) {
  final (data, isSelected, mode, currentPlanLabel) = _getArgs(context);

  return RadioGroup(
    onChanged: (_) {},
    groupValue: true,
    child: PlanCard.features(
      data: data,
      value: isSelected,
      mode: mode,
      currentPlanLabel: currentPlanLabel,
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
  final (data, isSelected, mode, currentPlanLabel) = _getArgs(context);
  return RadioGroup(
    onChanged: (_) {},
    groupValue: true,
    child: PlanCard.actions(
      data: data,
      value: isSelected,
      mode: mode,
      currentPlanLabel: currentPlanLabel,
      onPressed: () {},
      text: 'Choose Plan',
    ),
  );
}

// Stacked picker demo: shows the user's "current plan" alongside an
// upgrade option so the visual treatment (badge + no radio + no
// selected-border) reads in context.
@UseCase(name: 'Current plan (in a picker)', type: PlanCard)
Widget buildPlanCardCurrent(BuildContext context) {
  final currentPlanLabel = context.knobs.string(
    label: 'Current plan label',
    initialValue: 'Your plan',
  );
  final theme = Theme.of(context);
  const currentPlan = PlanData(
    name: 'Free',
    fullPriceLabel: 'Total',
    fullPrice: r'$0',
    periodLabel: '/mo',
    perMonth: '/mo',
  );
  const paidPlan = PlanData(
    name: 'Plus',
    fullPriceLabel: 'Yearly',
    fullPrice: r'$119.88',
    discountedLabel: 'Monthly',
    monthlyFullPrice: r'$14.99',
    monthlyDiscountedPrice: r'$9.99',
    promoBadge: '20% OFF',
    periodLabel: 'year',
    perMonth: 'mo',
  );

  return RadioGroup<int>(
    onChanged: (_) {},
    groupValue: 1,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: theme.spacing.ms,
        children: [
          PlanCard<int>(data: currentPlan, value: 0, currentPlanLabel: currentPlanLabel),
          const PlanCard<int>(data: paidPlan, value: 1),
        ],
      ),
    ),
  );
}

(PlanData, bool, PlanCardMode, String?) _getArgs(BuildContext context) {
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
  final currentPlanLabel = context.knobs.stringOrNull(
    label: 'Current plan label',
    description:
        "When set, this card renders as the user's active plan "
        '(badge replaces radio, tap + selected-border are suppressed).',
  );

  return (data, isSelected, mode, currentPlanLabel);
}
