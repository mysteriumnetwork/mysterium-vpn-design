import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

// Albania flag placeholder: red field, roughly matching the Figma fixture.
final _albaniaFlag = WidgetbookUtils.placeholderFlag(const [Color(0xFFE41E20)]);

@UseCase(name: 'SavedIpCard', type: SavedIpCard)
Widget buildSavedIpCard(BuildContext context) {
  final type = context.knobs.object.dropdown(
    label: 'Type',
    options: SavedIpCardType.values,
    initialOption: SavedIpCardType.favorite,
    labelBuilder: (t) => t.name,
  );
  final status = context.knobs.object.dropdown(
    label: 'Status',
    options: SavedIpCardStatus.values,
    initialOption: SavedIpCardStatus.idle,
    labelBuilder: (s) => s.name,
  );
  final isFavorite = context.knobs.boolean(label: 'Is favorite', initialValue: true);
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 343),
      child: SavedIpCard(
        countryIcon: _albaniaFlag,
        name: context.knobs.string(label: 'Name', initialValue: 'Albania'),
        subtitle: context.knobs.string(label: 'Subtitle', initialValue: 'Tirana'),
        ipAddress: context.knobs.string(label: 'IP address', initialValue: '195.285.15.404'),
        badgeLabel: context.knobs.string(label: 'Badge label', initialValue: 'Residential IP'),
        type: type,
        status: status,
        isFavorite: isFavorite,
        onTap: () {},
        onFavoriteTap: () {},
        favoriteSemanticLabel: isFavorite ? 'Remove from favourites' : 'Save to favourites',
      ),
    ),
  );
}

@UseCase(name: 'All variants', type: SavedIpCard)
Widget buildSavedIpCardVariants(BuildContext context) => Padding(
  padding: const EdgeInsets.all(16),
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 343),
    child: Column(
      spacing: 16,
      children: [
        SavedIpCard(
          countryIcon: _albaniaFlag,
          name: 'Albania',
          subtitle: 'Tirana',
          ipAddress: '195.285.15.404',
          badgeLabel: 'Residential IP',
          onTap: () {},
          onFavoriteTap: () {},
        ),
        SavedIpCard(
          countryIcon: _albaniaFlag,
          name: 'Albania',
          subtitle: 'Tirana',
          ipAddress: '195.285.15.404',
          badgeLabel: 'Residential IP',
          isFavorite: false,
          onTap: () {},
          onFavoriteTap: () {},
        ),
        SavedIpCard(
          countryIcon: _albaniaFlag,
          name: 'Albania',
          subtitle: 'Tirana',
          ipAddress: '195.285.15.404',
          badgeLabel: 'Residential IP',
          type: SavedIpCardType.locked,
          onTap: () {},
        ),
        SavedIpCard(
          countryIcon: _albaniaFlag,
          name: 'Albania',
          subtitle: 'Tirana',
          ipAddress: '195.285.15.404',
          badgeLabel: 'Residential IP',
          type: SavedIpCardType.locked,
          status: SavedIpCardStatus.disabled,
        ),
        SavedIpCard(
          countryIcon: _albaniaFlag,
          name: 'Albania',
          subtitle: 'Tirana',
          ipAddress: '195.285.15.404',
          badgeLabel: 'Residential IP',
          status: SavedIpCardStatus.connected,
          onTap: () {},
          onFavoriteTap: () {},
        ),
      ],
    ),
  ),
);
