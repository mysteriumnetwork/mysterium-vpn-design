import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('AppBadge', () {
    testWidgets('renders text', (tester) async {
      await pumpWidget(tester, const AppBadge(text: 'New'));
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('renders with each BadgeType without error', (tester) async {
      for (final type in BadgeType.values) {
        await pumpWidget(tester, AppBadge(text: type.name, type: type));
        expect(find.text(type.name), findsOneWidget);
      }
    });

    testWidgets('renders with each BadgeSize without error', (tester) async {
      for (final size in BadgeSize.values) {
        await pumpWidget(tester, AppBadge(text: 'Badge', size: size));
        expect(find.text('Badge'), findsOneWidget);
      }
    });
  });
}
