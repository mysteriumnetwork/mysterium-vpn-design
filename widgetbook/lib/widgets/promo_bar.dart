import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'PromoBar', type: PromoBar)
Widget buildPromoBar(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'Upgrade to Plus and unlock all features',
  );
  final hasIcon = context.knobs.boolean(label: 'Show leading icon', initialValue: true);
  final tappable = context.knobs.boolean(label: 'Tappable', initialValue: true);
  return PromoBar(
    text: text,
    onTap: tappable ? () {} : null,
    icon: hasIcon ? const Icon(UntitledUI.stars_01) : null,
  );
}
