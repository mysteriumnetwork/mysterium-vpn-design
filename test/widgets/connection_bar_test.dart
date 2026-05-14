import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('ConnectionBar', () {
    const base = ConnectionBar(label: 'Connected', status: BarStatus.connected);

    testWidgets('renders label', (tester) async {
      await pumpWidget(tester, base, wrapInScaffold: true);
      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('all statuses render without error', (tester) async {
      for (final status in BarStatus.values) {
        await pumpWidget(
          tester,
          ConnectionBar(label: status.name, status: status),
          wrapInScaffold: true,
        );
        expect(find.text(status.name), findsOneWidget);
      }
    });
  });
}
