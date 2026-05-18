import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

// Minimal valid 1×1 transparent PNG bytes — used to satisfy the Image loader
// in tests without depending on an asset bundle entry.
final _kTransparentPixelPng = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, //
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, //
  0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, //
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, //
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, //
  0x42, 0x60, 0x82, //
]);

void main() {
  group('OnboardingComparisonCard', () {
    final placeholderImage = MemoryImage(_kTransparentPixelPng);

    final dataCentre = OnboardingComparisonCard(
      variant: OnboardingComparisonCardVariant.dataCentre,
      pillLabel: 'DATA CENTRE IPS',
      title: 'Most VPNs',
      items: const ['Easily detectable', 'Often blocked by websites', 'Less private'],
      image: placeholderImage,
    );

    final residential = OnboardingComparisonCard(
      variant: OnboardingComparisonCardVariant.residential,
      pillLabel: 'RESIDENTIAL IPS',
      title: 'Mysterium VPN',
      items: const ['Looks like a real user', 'Harder to detect', 'Fewer blocks'],
      image: placeholderImage,
    );

    testWidgets('renders title, pill label and items (data centre)', (tester) async {
      await pumpWidget(tester, dataCentre);

      expect(find.text('Most VPNs'), findsOneWidget);
      expect(find.text('DATA CENTRE IPS'), findsOneWidget);
      expect(find.text('Easily detectable'), findsOneWidget);
      expect(find.text('Often blocked by websites'), findsOneWidget);
      expect(find.text('Less private'), findsOneWidget);
    });

    testWidgets('renders title, pill label and items (residential)', (tester) async {
      await pumpWidget(tester, residential);

      expect(find.text('Mysterium VPN'), findsOneWidget);
      expect(find.text('RESIDENTIAL IPS'), findsOneWidget);
      expect(find.text('Looks like a real user'), findsOneWidget);
      expect(find.text('Harder to detect'), findsOneWidget);
      expect(find.text('Fewer blocks'), findsOneWidget);
    });

    testWidgets('data centre variant uses x icons, one per item', (tester) async {
      await pumpWidget(tester, dataCentre);

      expect(find.byIcon(UntitledUI.x_close), findsNWidgets(3));
      expect(find.byIcon(UntitledUI.check), findsNothing);
    });

    testWidgets('residential variant uses check icons, one per item', (tester) async {
      await pumpWidget(tester, residential);

      expect(find.byIcon(UntitledUI.check), findsNWidgets(3));
      expect(find.byIcon(UntitledUI.x_close), findsNothing);
    });

    testWidgets('renders in dark theme', (tester) async {
      await pumpWidget(tester, residential, theme: DesignSystem.darkTheme);

      expect(find.text('Mysterium VPN'), findsOneWidget);
      expect(find.byIcon(UntitledUI.check), findsNWidgets(3));
    });

    testWidgets('honours an empty items list', (tester) async {
      await pumpWidget(
        tester,
        OnboardingComparisonCard(
          variant: OnboardingComparisonCardVariant.residential,
          pillLabel: 'RESIDENTIAL IPS',
          title: 'Mysterium VPN',
          items: const [],
          image: placeholderImage,
        ),
      );

      expect(find.text('Mysterium VPN'), findsOneWidget);
      expect(find.byIcon(UntitledUI.check), findsNothing);
    });

    testWidgets('renders the supplied image', (tester) async {
      final customImage = MemoryImage(_kTransparentPixelPng);
      await pumpWidget(
        tester,
        OnboardingComparisonCard(
          variant: OnboardingComparisonCardVariant.dataCentre,
          pillLabel: 'DATA CENTRE IPS',
          title: 'Most VPNs',
          items: const ['Easily detectable'],
          image: customImage,
        ),
      );

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, customImage);
    });

    testWidgets('contentTrailingPadding overrides the body trailing padding', (tester) async {
      const trailingPadding = 80.0;
      await pumpWidget(
        tester,
        OnboardingComparisonCard(
          variant: OnboardingComparisonCardVariant.dataCentre,
          pillLabel: 'DATA CENTRE IPS',
          title: 'Most VPNs',
          items: const ['Easily detectable'],
          image: placeholderImage,
          contentTrailingPadding: trailingPadding,
        ),
      );

      final bodyPadding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(OnboardingComparisonCard),
          matching: find.byWidgetPredicate(
            (w) => w is Padding && w.padding is EdgeInsetsDirectional,
          ),
        ),
      );
      final resolved = bodyPadding.padding.resolve(TextDirection.ltr);
      expect(resolved.right, trailingPadding);
      expect(resolved.left, 16);
      expect(resolved.top, 16);
      expect(resolved.bottom, 16);
    });

    testWidgets('defaults to standard body padding on all sides when not set', (tester) async {
      await pumpWidget(tester, dataCentre);

      final bodyPadding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(OnboardingComparisonCard),
          matching: find.byWidgetPredicate(
            (w) => w is Padding && w.padding is EdgeInsetsDirectional,
          ),
        ),
      );
      final resolved = bodyPadding.padding.resolve(TextDirection.ltr);
      expect(resolved.left, 16);
      expect(resolved.right, 16);
      expect(resolved.top, 16);
      expect(resolved.bottom, 16);
    });

    testWidgets('respects fixed width when supplied', (tester) async {
      await pumpWidget(
        tester,
        Align(
          alignment: Alignment.topLeft,
          child: OnboardingComparisonCard(
            variant: OnboardingComparisonCardVariant.residential,
            pillLabel: 'RESIDENTIAL IPS',
            title: 'Mysterium VPN',
            items: const ['Looks like a real user'],
            image: placeholderImage,
            width: 194,
          ),
        ),
      );

      final size = tester.getSize(find.byType(OnboardingComparisonCard));
      expect(size.width, 194);
    });
  });
}
