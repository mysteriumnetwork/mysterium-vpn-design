import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// 1×1 transparent PNG — placeholder for the illustration so the card has a
// valid [ImageProvider] without depending on a host-app asset.
final _placeholderImage = MemoryImage(
  Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, //
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, //
    0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, //
    0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, //
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, //
    0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, //
    0x42, 0x60, 0x82, //
  ]),
);

@UseCase(name: 'Data centre (Most VPNs)', type: OnboardingComparisonCard)
Widget buildOnboardingComparisonCardDataCentre(BuildContext context) => Padding(
  padding: const EdgeInsets.all(24),
  child: Center(
    child: OnboardingComparisonCard(
      variant: OnboardingComparisonCardVariant.dataCentre,
      pillLabel: context.knobs.string(label: 'Pill label', initialValue: 'DATA CENTRE IPS'),
      title: context.knobs.string(label: 'Title', initialValue: 'Most VPNs'),
      items: [
        context.knobs.string(label: 'Item 1', initialValue: 'Easily detectable'),
        context.knobs.string(label: 'Item 2', initialValue: 'Often blocked by websites'),
        context.knobs.string(label: 'Item 3', initialValue: 'Less private'),
      ],
      image: _placeholderImage,
      width: context.knobs.double.input(label: 'Width', initialValue: 188),
    ),
  ),
);

@UseCase(name: 'Residential (Mysterium VPN)', type: OnboardingComparisonCard)
Widget buildOnboardingComparisonCardResidential(BuildContext context) => Padding(
  padding: const EdgeInsets.all(24),
  child: Center(
    child: OnboardingComparisonCard(
      variant: OnboardingComparisonCardVariant.residential,
      pillLabel: context.knobs.string(label: 'Pill label', initialValue: 'RESIDENTIAL IPS'),
      title: context.knobs.string(label: 'Title', initialValue: 'Mysterium VPN'),
      items: [
        context.knobs.string(label: 'Item 1', initialValue: 'Looks like a real user'),
        context.knobs.string(label: 'Item 2', initialValue: 'Harder to detect'),
        context.knobs.string(label: 'Item 3', initialValue: 'Fewer blocks'),
      ],
      image: _placeholderImage,
      width: context.knobs.double.input(label: 'Width', initialValue: 194),
    ),
  ),
);

@UseCase(name: 'Comparison (stacked)', type: OnboardingComparisonCard)
Widget buildOnboardingComparisonCardStacked(BuildContext context) => Padding(
  padding: const EdgeInsets.all(24),
  child: Center(
    child: SizedBox(
      width: 327,
      height: 320,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 24,
            top: 10,
            child: OnboardingComparisonCard(
              variant: OnboardingComparisonCardVariant.dataCentre,
              pillLabel: 'DATA CENTRE IPS',
              title: 'Most VPNs',
              items: const ['Easily detectable', 'Often blocked by websites', 'Less private'],
              image: _placeholderImage,
              width: 188,
            ),
          ),
          Positioned(
            left: 130,
            top: 89,
            child: OnboardingComparisonCard(
              variant: OnboardingComparisonCardVariant.residential,
              pillLabel: 'RESIDENTIAL IPS',
              title: 'Mysterium VPN',
              items: const ['Looks like a real user', 'Harder to detect', 'Fewer blocks'],
              image: _placeholderImage,
              width: 194,
            ),
          ),
        ],
      ),
    ),
  ),
);
