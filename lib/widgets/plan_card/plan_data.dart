import 'package:flutter/widgets.dart';

@immutable
class PlanData {
  const PlanData({
    required this.name,
    required this.price,
    required this.period,
    required this.billingInfo,
    this.oldPrice,
    this.promoBadge,
    this.bestValueBadge,
    this.icon,
  });

  final String name;
  final String price;
  final String period;
  final String billingInfo;

  final String? oldPrice;
  final String? promoBadge;
  final String? bestValueBadge;
  final IconData? icon;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PlanData &&
        other.name == name &&
        other.price == price &&
        other.period == period &&
        other.billingInfo == billingInfo &&
        other.oldPrice == oldPrice &&
        other.promoBadge == promoBadge &&
        other.bestValueBadge == bestValueBadge &&
        other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(
        name,
        price,
        period,
        billingInfo,
        oldPrice,
        promoBadge,
        bestValueBadge,
        icon,
      );

  @override
  String toString() =>
      'PlanData(name: $name, price: $price, period: $period, billingInfo: $billingInfo, oldPrice: $oldPrice, promoBadge: $promoBadge, bestValueBadge: $bestValueBadge, icon: $icon)';
}
