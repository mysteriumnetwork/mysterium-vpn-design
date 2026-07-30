import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_workspace/widgetbook_utils.dart';

@UseCase(name: 'Not Connected', type: MainIpCard)
Widget buildMainIpCardNotConnected(BuildContext context) => MainIpCard(
  status: const MainIpCardNotConnected(),
  connectLabel: context.knobs.string(label: 'Connect label', initialValue: 'Connect'),
  noConnectionTitle: context.knobs.string(label: 'Title', initialValue: 'Fastest connection'),
  noConnectionDescription: context.knobs.string(
    label: 'Description',
    initialValue: "We'll connect you to the nearest server - or you can manually select a country.",
  ),
  disconnectLabel: 'Disconnect',
  connectingLabel: 'Connecting',
  onConnect: () {},
);

@UseCase(name: 'Location Selected', type: MainIpCard)
Widget buildMainIpCardLocationSelected(BuildContext context) {
  final country = context.knobs.string(label: 'Country', initialValue: 'France');
  final serviceQuality = context.knobs.string(label: 'Service quality', initialValue: 'High-speed');
  final connectLabel = context.knobs.string(label: 'Connect label', initialValue: 'Connect');
  return MainIpCard(
    status: MainIpCardLocationSelected(
      country: country,
      countryIcon: _franceFlag,
      serviceQuality: serviceQuality,
    ),
    connectLabel: connectLabel,
    disconnectLabel: 'Disconnect',
    connectingLabel: 'Connecting',
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
    onConnect: () {},
  );
}

@UseCase(name: 'Connecting', type: MainIpCard)
Widget buildMainIpCardConnecting(BuildContext context) {
  final country = context.knobs.string(label: 'Country', initialValue: 'France');
  final serviceQuality = context.knobs.string(label: 'Service quality', initialValue: 'High-speed');
  final connectingLabel = context.knobs.string(
    label: 'Connecting label',
    initialValue: 'Connecting',
  );
  return MainIpCard(
    status: MainIpCardConnecting(
      country: country,
      countryIcon: _franceFlag,
      serviceQuality: serviceQuality,
    ),
    connectLabel: 'Connect',
    disconnectLabel: 'Disconnect',
    connectingLabel: connectingLabel,
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
  );
}

@UseCase(name: 'Connected', type: MainIpCard)
Widget buildMainIpCardConnected(BuildContext context) {
  final country = context.knobs.string(label: 'Country', initialValue: 'France');
  final city = context.knobs.string(label: 'City', initialValue: 'Paris');
  final ipAddress = context.knobs.string(label: 'IP address', initialValue: '195.285.15.404');
  final disconnectLabel = context.knobs.string(
    label: 'Disconnect label',
    initialValue: 'Disconnect',
  );
  final showFavorite = context.knobs.boolean(label: 'Show favorite', initialValue: true);
  return MainIpCard(
    status: MainIpCardConnected(
      country: country,
      countryIcon: _franceFlag,
      city: city,
      ipAddress: ipAddress,
    ),
    connectLabel: 'Connect',
    disconnectLabel: disconnectLabel,
    connectingLabel: 'Connecting',
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
    onDisconnect: () {},
    onDetails: () {},
    onFavorite: showFavorite ? () {} : null,
    favoriteTooltip: context.knobs.string(
      label: 'Favorite tooltip',
      initialValue: 'Favorites coming soon',
    ),
  );
}

@UseCase(name: 'New IP Preview', type: MainIpCard)
Widget buildMainIpCardNewIpPreview(BuildContext context) {
  final country = context.knobs.string(label: 'Country', initialValue: 'France');
  final city = context.knobs.string(label: 'City', initialValue: 'Paris');
  final ipAddress = context.knobs.string(label: 'IP address', initialValue: '195.285.15.404');
  final previewCountry = context.knobs.string(label: 'Preview country', initialValue: 'Poland');
  final switchLabel = context.knobs.string(label: 'Switch label', initialValue: 'Switch to Poland');
  return MainIpCard(
    status: MainIpCardNewIpPreview(
      country: country,
      countryIcon: _franceFlag,
      city: city,
      ipAddress: ipAddress,
      previewCountry: previewCountry,
      previewCountryIcon: _polandFlag,
      switchLabel: switchLabel,
    ),
    connectLabel: 'Connect',
    disconnectLabel: 'Disconnect',
    connectingLabel: 'Connecting',
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
    onSwitchCountry: () {},
    onDismissPreview: () {},
    onDetails: () {},
    onFavorite: () {},
  );
}

// ─── Flag placeholders ────────────────────────────────────────────────────────

final _franceFlag = WidgetbookUtils.placeholderFlag(const [
  Color(0xFF0055A4),
  Colors.white,
  Color(0xFFEF4135),
], axis: Axis.horizontal);

final _polandFlag = WidgetbookUtils.placeholderFlag(const [Colors.white, Color(0xFFDC143C)]);
