import 'package:flutter/material.dart' hide Badge;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Radius;

part 'plan_card/plan_best_value_banner.dart';
part 'plan_card/plan_card_action.dart';
part 'plan_card/plan_card_features.dart';
part 'plan_card/plan_container.dart';

enum PlanCardMode { selectable, highlight, normal }

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
    required String viewMoreLabel,
    required String viewLessLabel,
    this.radioGroup,
    this.value,
    this.mode = PlanCardMode.selectable,
    super.key,
  }) : footer = _PlanCardFeatures(
         features: features,
         viewMoreLabel: viewMoreLabel,
         viewLessLabel: viewLessLabel,
         isOffer: data.isOffer,
       );

  PlanCard.actions({
    required this.data,
    required VoidCallback onPressed,
    required String text,
    IconData? actionIcon,
    this.radioGroup,
    this.value,
    this.mode = PlanCardMode.selectable,
    super.key,
  }) : footer = _PlanCardAction(onPressed: onPressed, text: text, icon: actionIcon);

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (data.isOffer && data.promoBadge != null)
            Row(
              children: [
                AppBadge(
                  text: data.promoBadge!,
                  size: BadgeSize.small,
                  type: BadgeType.greenSecondary,
                ),
              ],
            ),
          _PlanPricing(data: data, showRadio: mode == PlanCardMode.selectable, radioValue: value),
          if (footer != null) ...[SizedBox(height: theme.spacing.s), footer!],
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
  const _PlanPricing({required this.data, this.showRadio = false, this.radioValue});

  final PlanData data;
  final bool showRadio;
  final dynamic radioValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMonthlyPricing = data.monthlyFullPrice != null && data.monthlyDiscountedPrice != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!data.isOffer)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  spacing: theme.spacing.s,
                  children: [
                    if (data.icon != null)
                      DecoratedIcon(
                        icon: data.icon!,
                        decoration: IconDecoration(
                          backgroundColor: theme.palette.bgSecondarySelected,
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.all(theme.radius.xxs),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        data.name,
                        maxLines: 1,
                        style: theme.textStyles.textMd.bold,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              if (data.promoBadge != null && !data.isOffer)
                AppBadge(
                  text: data.promoBadge!,
                  size: BadgeSize.small,
                  type: BadgeType.greenSecondary,
                ),
            ],
          ),
        SizedBox(height: theme.spacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasMonthlyPricing)
                    Padding(
                      padding: EdgeInsets.only(bottom: theme.spacing.xs),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            if (data.discountedLabel != null)
                              TextSpan(
                                text: '${data.discountedLabel} ',
                                style: theme.textStyles.textMd.regular,
                              ),
                            TextSpan(
                              text: data.monthlyFullPrice,
                              style: theme.textStyles.textMd.regular.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            CharacterSpan.space(),
                            TextSpan(
                              text: data.monthlyDiscountedPrice,
                              style: theme.textStyles.textLg.bold.copyWith(fontSize: 20),
                            ),
                            CharacterSpan.slash(),
                            TextSpan(text: data.perMonth),
                          ],
                        ),
                        maxLines: 1,
                        style: theme.textStyles.textMd.regular,
                      ),
                    ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: data.fullPriceLabel, style: theme.textStyles.textMd.regular),
                        CharacterSpan.space(),
                        TextSpan(
                          text: data.fullPrice,
                          style: theme.textStyles.textLg.bold.copyWith(fontSize: 20),
                        ),
                        CharacterSpan.slash(),
                        TextSpan(text: data.periodLabel, style: theme.textStyles.textMd.regular),
                      ],
                    ),
                    maxLines: 1,
                    style: theme.textStyles.textSm.regular.copyWith(
                      color: theme.palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (showRadio)
              SizedBox(
                width: 20,
                height: 20,
                child: Align(
                  child: IgnorePointer(child: RadioButton(value: radioValue)),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
