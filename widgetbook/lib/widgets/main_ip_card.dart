import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

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
  connectionRatingLabel: 'How is your connection?',
  refreshIpTooltip: 'Refresh IP address',

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
      countryIcon: const _FranceFlag(),
      serviceQuality: serviceQuality,
    ),
    connectLabel: connectLabel,
    disconnectLabel: 'Disconnect',
    connectingLabel: 'Connecting',
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
    refreshIpTooltip: 'Refresh IP address',

    connectionRatingLabel: 'How is your connection?',
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
      countryIcon: const _FranceFlag(),
      serviceQuality: serviceQuality,
    ),
    connectLabel: 'Connect',
    disconnectLabel: 'Disconnect',
    connectingLabel: connectingLabel,
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
    refreshIpTooltip: 'Refresh IP address',

    connectionRatingLabel: 'How is your connection?',
  );
}

@UseCase(name: 'Connected', type: MainIpCard)
Widget buildMainIpCardConnected(BuildContext context) {
  final country = context.knobs.string(label: 'Country', initialValue: 'France');
  final city = context.knobs.string(label: 'City', initialValue: 'Paris');
  final ipAddress = context.knobs.string(label: 'IP address', initialValue: '195.285.15.404');
  final serviceQuality = context.knobs.string(label: 'Service quality', initialValue: 'High-speed');
  final ipPoolCount = context.knobs.int.input(label: 'IP pool count', initialValue: 13);
  final disconnectLabel = context.knobs.string(
    label: 'Disconnect label',
    initialValue: 'Disconnect',
  );
  final connectionRatingLabel = context.knobs.string(
    label: 'Rating label',
    initialValue: 'How is your connection?',
  );
  final rating = context.knobs.object.dropdown(
    label: 'Connection rating',
    options: ConnectionRating.values,
    initialOption: ConnectionRating.none,
    labelBuilder: (r) => r.name,
  );
  return MainIpCard(
    status: MainIpCardConnected(
      country: country,
      countryIcon: const _FranceFlag(),
      city: city,
      ipAddress: ipAddress,
      serviceQuality: serviceQuality,
      ipPoolCount: ipPoolCount,
    ),
    connectLabel: 'Connect',
    disconnectLabel: disconnectLabel,
    connectingLabel: 'Connecting',
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
    refreshIpTooltip: 'Refresh IP address',

    connectionRatingLabel: connectionRatingLabel,
    connectionRating: rating,
    onDisconnect: () {},
    onRefreshIp: () {},
    onThumbsUp: () {},
    onThumbsDown: () {},
  );
}

@UseCase(name: 'New IP Preview', type: MainIpCard)
Widget buildMainIpCardNewIpPreview(BuildContext context) {
  final country = context.knobs.string(label: 'Country', initialValue: 'France');
  final city = context.knobs.string(label: 'City', initialValue: 'Paris');
  final ipAddress = context.knobs.string(label: 'IP address', initialValue: '195.285.15.404');
  final serviceQuality = context.knobs.string(label: 'Service quality', initialValue: 'High-speed');
  final ipPoolCount = context.knobs.int.input(label: 'IP pool count', initialValue: 13);
  final previewCountry = context.knobs.string(label: 'Preview country', initialValue: 'Poland');
  final switchLabel = context.knobs.string(label: 'Switch label', initialValue: 'Switch to Poland');
  final connectionRatingLabel = context.knobs.string(
    label: 'Rating label',
    initialValue: 'How is your connection?',
  );
  final rating = context.knobs.object.dropdown(
    label: 'Connection rating',
    options: ConnectionRating.values,
    initialOption: ConnectionRating.none,
    labelBuilder: (r) => r.name,
  );
  return MainIpCard(
    status: MainIpCardNewIpPreview(
      country: country,
      countryIcon: const _FranceFlag(),
      city: city,
      ipAddress: ipAddress,
      serviceQuality: serviceQuality,
      ipPoolCount: ipPoolCount,
      previewCountry: previewCountry,
      previewCountryIcon: const _PolandFlag(),
      switchLabel: switchLabel,
    ),
    connectLabel: 'Connect',
    disconnectLabel: 'Disconnect',
    connectingLabel: 'Connecting',
    noConnectionTitle: 'Fastest connection',
    noConnectionDescription: "We'll connect you to the nearest server.",
    refreshIpTooltip: 'Refresh IP address',
    connectionRatingLabel: connectionRatingLabel,
    connectionRating: rating,
    onSwitchCountry: () {},
    onDismissPreview: () {},
    onRefreshIp: () {},
    onThumbsUp: () {},
    onThumbsDown: () {},
  );
}

// ─── Flag placeholders ────────────────────────────────────────────────────────

class _FranceFlag extends StatelessWidget {
  const _FranceFlag();

  @override
  Widget build(BuildContext context) => const ClipOval(
    child: Row(
      children: [
        Expanded(
          child: ColoredBox(color: Color(0xFF0055A4), child: SizedBox.expand()),
        ),
        Expanded(
          child: ColoredBox(color: Colors.white, child: SizedBox.expand()),
        ),
        Expanded(
          child: ColoredBox(color: Color(0xFFEF4135), child: SizedBox.expand()),
        ),
      ],
    ),
  );
}

class _PolandFlag extends StatelessWidget {
  const _PolandFlag();

  @override
  Widget build(BuildContext context) => const ClipOval(
    child: Column(
      children: [
        Expanded(
          child: ColoredBox(color: Colors.white, child: SizedBox.expand()),
        ),
        Expanded(
          child: ColoredBox(color: Color(0xFFDC143C), child: SizedBox.expand()),
        ),
      ],
    ),
  );
}
