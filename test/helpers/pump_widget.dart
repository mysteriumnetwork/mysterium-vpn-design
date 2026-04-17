import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Wraps [child] in a themed MaterialApp for widget testing.
///
/// Provides DesignSystem theme, optional ScreenType override, and a
/// Navigator (needed by Header and modal widgets).
Future<void> pumpWidget(
  WidgetTester tester,
  Widget child, {
  ScreenType screenType = ScreenType.mobile,
  ThemeData? theme,
  bool wrapInScaffold = false,
}) async {
  final effectiveChild = wrapInScaffold ? Scaffold(body: child) : child;

  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? DesignSystem.lightTheme,
      home: ScreenTypeOverride(screenType: screenType, child: effectiveChild),
    ),
  );
}
