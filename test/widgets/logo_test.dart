import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('Logo', () {
    testWidgets('renders an SVG on the light theme', (tester) async {
      await pumpWidget(tester, const Logo(width: 120));
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders an SVG on the dark theme', (tester) async {
      await pumpWidget(tester, const Logo(width: 120), theme: DesignSystem.darkTheme);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
