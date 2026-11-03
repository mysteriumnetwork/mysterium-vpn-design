import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/haptics.dart';

void main() {
  group('HapticLevel', () {
    testWidgets('each level fires its documented feedback type', (tester) async {
      final fired = recordHaptics(tester);

      HapticLevel.selection.fire();
      HapticLevel.press.fire();
      HapticLevel.impact.fire();

      expect(fired, [
        'HapticFeedbackType.selectionClick',
        'HapticFeedbackType.lightImpact',
        'HapticFeedbackType.mediumImpact',
      ]);
    });

    testWidgets('notification levels map to the notification generators', (tester) async {
      final fired = recordHaptics(tester);

      HapticLevel.success.fire();
      HapticLevel.warning.fire();
      HapticLevel.error.fire();

      expect(fired, [
        'HapticFeedbackType.successNotification',
        'HapticFeedbackType.warningNotification',
        'HapticFeedbackType.errorNotification',
      ]);
    });

    testWidgets('the master switch silences everything', (tester) async {
      final fired = recordHaptics(tester);
      HapticLevel.enabled = false;
      addTearDown(() => HapticLevel.enabled = true);
      var called = false;

      HapticLevel.success.fire();
      HapticLevel.selection.wrap(() => called = true)!();

      expect(fired, isEmpty);
      expect(called, isTrue);
    });

    testWidgets('a callback wrapped while disabled fires once re-enabled', (tester) async {
      final fired = recordHaptics(tester);
      HapticLevel.enabled = false;
      addTearDown(() => HapticLevel.enabled = true);
      final tap = HapticLevel.selection.wrap(() {})!;

      HapticLevel.enabled = true;
      tap();

      expect(fired, ['HapticFeedbackType.selectionClick']);
    });

    testWidgets('none fires nothing', (tester) async {
      final fired = recordHaptics(tester);

      HapticLevel.none.fire();

      expect(fired, isEmpty);
    });

    testWidgets('wrap returns null for a null callback', (tester) async {
      for (final level in HapticLevel.values) {
        expect(level.wrap(null), isNull, reason: '$level');
      }
    });

    testWidgets('wrap fires before invoking the callback', (tester) async {
      final fired = recordHaptics(tester);
      var called = false;

      HapticLevel.press.wrap(() => called = true)!();

      expect(fired, ['HapticFeedbackType.lightImpact']);
      expect(called, isTrue);
    });

    testWidgets('none still invokes the callback without firing', (tester) async {
      final fired = recordHaptics(tester);
      var called = false;

      HapticLevel.none.wrap(() => called = true)!();

      expect(called, isTrue);
      expect(fired, isEmpty);
    });

    testWidgets('no-ops off mobile', (tester) async {
      // Must be restored inside the body: the binding asserts foundation debug
      // vars are unset before addTearDown callbacks run.
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      final fired = recordHaptics(tester);
      var called = false;
      try {
        HapticLevel.impact.fire();
        HapticLevel.selection.wrap(() => called = true)!();
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }

      expect(fired, isEmpty);
      expect(called, isTrue);
    });
  });
}
