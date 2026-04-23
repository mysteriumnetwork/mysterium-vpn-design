import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('MapLocationMarker', () {
    testWidgets('renders inactive dot when not connected and not selected', (tester) async {
      await pumpWidget(tester, MapLocationMarker(onPressed: () {}));
      expect(find.byType(MapLocationMarker), findsOneWidget);
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var pressed = false;
      await pumpWidget(tester, MapLocationMarker(onPressed: () => pressed = true));
      await tester.tap(find.byType(MapLocationMarker));
      expect(pressed, isTrue);
    });

    testWidgets('renders selected state without error', (tester) async {
      await pumpWidget(tester, MapLocationMarker(isSelected: true, onPressed: () {}));
      expect(find.byType(MapLocationMarker), findsOneWidget);
    });

    testWidgets('renders connected state without error', (tester) async {
      await pumpWidget(tester, MapLocationMarker(isConnected: true, onPressed: () {}));
      expect(find.byType(MapLocationMarker), findsOneWidget);
    });
  });

  group('MapLocationTooltip', () {
    testWidgets('renders "Connect to <label>"', (tester) async {
      await pumpWidget(tester, const MapLocationTooltip(label: 'Berlin'));
      expect(find.text('Connect to Berlin'), findsOneWidget);
    });
  });
}
