import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('ProgressBar', () {
    testWidgets('linear renders LinearProgressIndicator on Android', (tester) async {
      // act
      await pumpWidget(
        tester,
        const ProgressBar(type: ProgressBarType.linear, value: 0.5, width: 200),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );

      // assert
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('circular renders CircularProgressIndicator on Android', (tester) async {
      // act
      await pumpWidget(
        tester,
        const ProgressBar(type: ProgressBarType.circular, value: 0.5, width: 48, height: 48),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('.linear factory sets linear type', (tester) async {
      // act
      await pumpWidget(
        tester,
        ProgressBar.linear(value: 0.25, width: 120),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );

      // assert
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 0.25);
    });

    testWidgets('.circular factory sets circular type', (tester) async {
      // act
      await pumpWidget(
        tester,
        ProgressBar.circular(value: 0.75, width: 40, height: 40),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );

      // assert
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, 0.75);
    });

    testWidgets('uses custom foreground and background colors', (tester) async {
      await pumpWidget(
        tester,
        const ProgressBar(
          type: ProgressBarType.linear,
          value: 0.5,
          width: 100,
          backgroundColor: Colors.grey,
          color: Colors.blue,
        ),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.color, Colors.blue);
      expect(indicator.backgroundColor, Colors.grey);
    });

    testWidgets('uses default palette colors in light theme', (tester) async {
      final theme = DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android);
      await pumpWidget(
        tester,
        const ProgressBar(type: ProgressBarType.linear, value: 0.5, width: 100),
        theme: theme,
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.color, theme.palette.iconBrandSecondary);
      expect(indicator.backgroundColor, Palette.grayPurple.shade700);
    });

    testWidgets('uses default palette colors in dark theme', (tester) async {
      final theme = DesignSystem.darkTheme.copyWith(platform: TargetPlatform.android);
      await pumpWidget(
        tester,
        const ProgressBar(type: ProgressBarType.linear, value: 0.5, width: 100),
        theme: theme,
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.color, theme.palette.iconBrandSecondary);
      expect(indicator.backgroundColor, theme.palette.bgTertiary);
    });

    testWidgets('indeterminate on iOS renders CupertinoActivityIndicator', (tester) async {
      final theme = DesignSystem.lightTheme.copyWith(platform: TargetPlatform.iOS);
      await pumpWidget(
        tester,
        const ProgressBar(type: ProgressBarType.circular, width: 24, height: 24),
        theme: theme,
      );

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      final indicator = tester.widget<CupertinoActivityIndicator>(
        find.byType(CupertinoActivityIndicator),
      );
      expect(indicator.color, theme.palette.iconPrimary);
    });

    testWidgets('indeterminate on Android renders Material circular indicator', (tester) async {
      await pumpWidget(
        tester,
        const ProgressBar(type: ProgressBarType.circular, width: 24, height: 24),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, isNull);
    });

    testWidgets('passes width and height to outer SizedBox', (tester) async {
      await pumpWidget(
        tester,
        const ProgressBar(type: ProgressBarType.linear, value: 0.5, width: 180, height: 8),
        theme: DesignSystem.lightTheme.copyWith(platform: TargetPlatform.android),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(of: find.byType(LinearProgressIndicator), matching: find.byType(SizedBox)),
      );
      expect(sizedBox.width, 180);
      expect(sizedBox.height, 8);
    });
  });
}
