import 'package:flutter/widgets.dart';

@immutable
class PlanData {
  const PlanData({
    required this.name,
    required this.fullPriceLabel,
    required this.fullPrice,
    required this.period,
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

  final String name;
  final String fullPriceLabel;
  final String fullPrice;
  final String? discountedLabel;
  final String? monthlyFullPrice;
  final String? monthlyDiscountedPrice;
  final String? promoBadge;
  final String? bestValueBadge;
  final IconData? icon;
  final bool isOffer;
  final String period;
  final String periodLabel;
  final String perMonth;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PlanData &&
        other.name == name &&
        other.fullPriceLabel == fullPriceLabel &&
        other.fullPrice == fullPrice &&
        other.period == period &&
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
        period,
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
      'PlanData(name: $name, fullPriceLabel: $fullPriceLabel, fullPrice: $fullPrice, period: $period, periodLabel: $periodLabel, perMonth: $perMonth, discountedLabel: $discountedLabel, monthlyFullPrice: $monthlyFullPrice, monthlyDiscountedPrice: $monthlyDiscountedPrice, promoBadge: $promoBadge, bestValueBadge: $bestValueBadge, icon: $icon, isOffer: $isOffer)';
}
