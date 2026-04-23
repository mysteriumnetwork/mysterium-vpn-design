import 'package:flutter/material.dart' hide Badge;
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Radius;

part 'plan_card/plan_best_value_banner.dart';
part 'plan_card/plan_card_action.dart';
part 'plan_card/plan_card_features.dart';
part 'plan_card/plan_container.dart';

/// Presentation mode of a [PlanCard].
enum PlanCardMode {
  /// Part of a [RadioGroup]-style picker; shows a radio control and
  /// reflects the group selection in its border.
  selectable,

  /// Always-highlighted card, e.g. a suggested or best-value plan.
  highlight,

  /// Neutral card with no selection affordance.
  normal,
}

/// A pricing card describing a single plan / offer.
///
/// Use [PlanCard.features] to attach an expandable feature list or
/// [PlanCard.actions] to attach a call-to-action row. Mode controls
/// whether the card participates in a [RadioGroup] of type [T].
class PlanCard<T> extends StatelessWidget {
  const PlanCard({
    required this.data,
    this.footer,
    this.radioGroup,
    this.value,
    this.mode = PlanCardMode.selectable,
    super.key,
  });

  /// Factory that attaches a collapsible feature list as the card footer.
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

  /// Factory that attaches a single call-to-action button as the footer.
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

  /// Pricing, name, icon, and badge data shown on the card.
  final PlanData data;

  /// Visual mode — selectable / highlight / normal.
  final PlanCardMode mode;

  /// Widget rendered below the pricing block (features list, action button).
  final Widget? footer;

  /// Optional explicit [RadioGroup] registry. Falls back to the nearest
  /// ancestor registry when null.
  final RadioGroupRegistry<T>? radioGroup;

  /// Value registered with the radio group for this card.
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
                          padding: EdgeInsets.all(theme.spacing.s),
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
