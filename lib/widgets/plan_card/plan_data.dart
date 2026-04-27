import 'package:flutter/widgets.dart';

/// Data model rendered by a `PlanCard`.
///
/// Fields come in two groups: full-period pricing ([fullPriceLabel] /
/// [fullPrice] / [periodLabel]) and optional monthly-equivalent pricing
/// ([monthlyFullPrice] / [monthlyDiscountedPrice] / [discountedLabel] /
/// [perMonth]). When both monthly prices are provided the card also shows
/// a struck-through full monthly price next to the discounted one.
@immutable
class PlanData {
  const PlanData({
    required this.name,
    required this.fullPriceLabel,
    required this.fullPrice,
    required this.periodLabel,
    required this.perMonth,
    this.discountedLabel,
    this.monthlyFullPrice,
    this.monthlyDiscountedPrice,
    this.promoBadge,
    this.bestValueBadge,
    this.icon,
    this.isOffer = false,
  });

  /// Plan name (e.g. "1-year plan").
  final String name;

  /// Label preceding [fullPrice] (e.g. "Total", "Pay once").
  final String fullPriceLabel;

  /// Full-period price formatted for display.
  final String fullPrice;

  /// Trailing period label after the price (e.g. "/year").
  final String periodLabel;

  /// Trailing monthly label for [monthlyDiscountedPrice] (e.g. "/mo").
  final String perMonth;

  /// Optional label preceding the monthly prices (e.g. "Just").
  final String? discountedLabel;

  /// Monthly price before discount. Rendered struck-through.
  final String? monthlyFullPrice;

  /// Discounted monthly price. Shown alongside [monthlyFullPrice].
  final String? monthlyDiscountedPrice;

  /// Optional badge shown next to the plan name (e.g. "Popular").
  final String? promoBadge;

  /// Optional "best value" banner rendered above the card.
  final String? bestValueBadge;

  /// Optional leading icon shown next to the plan name.
  final IconData? icon;

  /// When true the card renders in "offer" layout: the promo badge moves
  /// above the pricing block and the name / icon row is hidden.
  final bool isOffer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PlanData &&
        other.name == name &&
        other.fullPriceLabel == fullPriceLabel &&
        other.fullPrice == fullPrice &&
        other.periodLabel == periodLabel &&
        other.perMonth == perMonth &&
        other.discountedLabel == discountedLabel &&
        other.monthlyFullPrice == monthlyFullPrice &&
        other.monthlyDiscountedPrice == monthlyDiscountedPrice &&
        other.promoBadge == promoBadge &&
        other.bestValueBadge == bestValueBadge &&
        other.icon == icon &&
        other.isOffer == isOffer;
  }

  @override
  int get hashCode => Object.hash(
    name,
    fullPriceLabel,
    fullPrice,
    periodLabel,
    perMonth,
    discountedLabel,
    monthlyFullPrice,
    monthlyDiscountedPrice,
    promoBadge,
    bestValueBadge,
    icon,
    isOffer,
  );

  @override
  String toString() =>
      'PlanData(name: $name, fullPriceLabel: $fullPriceLabel, fullPrice: $fullPrice, periodLabel: $periodLabel, perMonth: $perMonth, discountedLabel: $discountedLabel, monthlyFullPrice: $monthlyFullPrice, monthlyDiscountedPrice: $monthlyDiscountedPrice, promoBadge: $promoBadge, bestValueBadge: $bestValueBadge, icon: $icon, isOffer: $isOffer)';
}
