import 'package:flutter/material.dart' hide Badge;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Radius;

part 'plan_card/plan_best_value_banner.dart';

part 'plan_card/plan_card_action.dart';

part 'plan_card/plan_card_features.dart';

part 'plan_card/plan_container.dart';

enum PlanCardMode {
  selectable,
  highlight,
  normal,
}

class PlanCard<T> extends StatelessWidget {
  const PlanCard({
    required this.data,
    this.footer,
    this.radioGroup,
    this.value,
    this.mode = PlanCardMode.selectable,
    super.key,
  });

  PlanCard.features({
    required this.data,
    required List<String> features,
    this.radioGroup,
    this.value,
    this.mode = PlanCardMode.selectable,
    super.key,
  }) : footer = _PlanCardFeatures(features: features);

  PlanCard.actions({
    required this.data,
    required VoidCallback onPressed,
    required String text,
    IconData? icon,
    this.radioGroup,
    this.value,
    this.mode = PlanCardMode.selectable,
    super.key,
  }) : footer = _PlanCardAction(onPressed: onPressed, text: text, icon: icon);

  final PlanData data;
  final PlanCardMode mode;
  final Widget? footer;
  final RadioGroupRegistry<T>? radioGroup;
  final T? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radioGroup = this.radioGroup ?? RadioButton.findGroupState<T>(context);
    final isSelected = _isSelected(radioGroup);

    void handleSelect() {
      radioGroup?.onChanged(value);
    }

    return _PlanContainer(
      isHighlighted: switch (mode) {
        PlanCardMode.highlight => true,
        PlanCardMode.selectable => isSelected,
        PlanCardMode.normal => false,
      },
      data: data,
      onTap: switch (mode) {
        PlanCardMode.selectable => handleSelect,
        _ => null,
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: theme.spacing.s,
        children: [
          if (data.icon != null)
            Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.palette.bgSecondarySelected,
                  borderRadius: BorderRadius.all(theme.radius.xs),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    data.icon,
                    size: 16,
                    color: theme.palette.iconBrandSecondary,
                  ),
                ),
              ),
            ),
          if (data.icon == null && mode == PlanCardMode.selectable && data.promoBadge != null)
            const SizedBox(height: 12),
          ClipRRect(
            child: Row(
              children: [
                Expanded(child: _PlanPricing(data: data)),
                if (mode == PlanCardMode.selectable)
                  IgnorePointer(child: RadioButton(value: value)),
              ],
            ),
          ),
          if (footer != null) Divider(color: theme.palette.borderQuaternary),
          if (footer != null) footer!,
        ],
      ),
    );
  }

  bool _isSelected(RadioGroupRegistry<T>? radioGroup) {
    if (mode != PlanCardMode.selectable || radioGroup == null) {
      return false;
    }
    return radioGroup.groupValue == value;
  }
}

class _PlanPricing extends StatelessWidget {
  const _PlanPricing({required this.data});

  final PlanData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      spacing: theme.spacing.xs,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          child: Row(
            spacing: theme.spacing.md,
            children: [
              Flexible(
                child: Text(
                  data.name,
                  maxLines: 1,
                  style: theme.textStyles.textLg.bold.copyWith(fontSize: 20),
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: data.price,
                        style: const TextStyle(fontSize: 20),
                      ),
                      CharacterSpan.slash(),
                      TextSpan(text: data.period),
                    ],
                  ),
                  maxLines: 1,
                  style: theme.textStyles.textSm.regular,
                ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              if (data.oldPrice != null)
                TextSpan(
                  text: data.oldPrice,
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: theme.palette.textErrorPrimary,
                  ),
                ),
              if (data.oldPrice != null) CharacterSpan.space(),
              TextSpan(text: data.billingInfo),
            ],
          ),
          maxLines: 3,
          style: theme.textStyles.textSm.regular.copyWith(
            color: theme.palette.textTertiary,
          ),
        ),
      ],
    );
  }
}
