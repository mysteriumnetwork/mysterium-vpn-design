import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'Features', type: PlanCard)
Widget buildPlanCardFeatures(BuildContext context) {
  final (data, isSelected, mode, icon) = _getArgs(context);

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
    ),
  );
}

@UseCase(name: 'Actions', type: PlanCard)
Widget buildPlanCardActions(BuildContext context) {
  final (data, isSelected, mode, icon) = _getArgs(context);
  return RadioGroup(
    onChanged: (_) {},
    groupValue: true,
    child: PlanCard.actions(
      data: data,
      value: isSelected,
      mode: mode,
      onPressed: () {},
      text: 'Choose Plan',
      icon: UntitledUI.chevron_down,
    ),
  );
}

(PlanData, bool, PlanCardMode, IconData?) _getArgs(BuildContext context) {
  final data = PlanData(
    name: context.knobs.string(label: 'Plan Name', initialValue: 'Plus'),
    price: context.knobs.string(label: 'Price', initialValue: r'$9.99'),
    period: context.knobs.string(label: 'Period', initialValue: 'mo'),
    billingInfo: context.knobs.string(
      label: 'Billing Info',
      initialValue: r'Billed $119.88 annually',
    ),
    bestValueBadge: context.knobs.stringOrNull(label: 'Best value', initialValue: 'Best Value'),
    oldPrice: context.knobs.stringOrNull(label: 'Old Price', initialValue: r'$144.99'),
    promoBadge: context.knobs.stringOrNull(label: 'Promo Badge', initialValue: '20% OFF'),
  );

  final isSelected = context.knobs.boolean(label: 'Is Selected');
  final mode = context.knobs.object.dropdown(
    label: 'Mode',
    options: PlanCardMode.values,
    labelBuilder: (mode) => mode.name,
  );

  final icon = context.knobs.object.dropdown(
    label: 'Icon',
    options: [null, ...WidgetbookUtils.namedIcons.values],
    labelBuilder: (item) => item == null ? 'None' : WidgetbookUtils.iconName(item),
  );

  return (data, isSelected, mode, icon);
}
