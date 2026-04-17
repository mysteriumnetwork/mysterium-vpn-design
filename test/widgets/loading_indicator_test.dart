import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('LoadingIndicator', () {
    testWidgets('renders on Android platform', (tester) async {
      await pumpWidget(
        tester,
        const LoadingIndicator(),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders Cupertino spinner on iOS', (tester) async {
      await pumpWidget(
        tester,
        const LoadingIndicator(),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.iOS),
      );
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('uses custom color', (tester) async {
      await pumpWidget(
        tester,
        const LoadingIndicator(color: Colors.red),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, Colors.red);
    });
  });
}
