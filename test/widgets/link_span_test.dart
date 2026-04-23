import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

void main() {
  group('LinkSpan', () {
    test('wires TapGestureRecognizer to onTap', () {
      var tapped = false;
      final span = LinkSpan(text: 'Terms', onTap: () => tapped = true);
      (span.recognizer! as TapGestureRecognizer).onTap!();
      expect(tapped, isTrue);
    });

    test('applies underline and brand color by default', () {
      final span = LinkSpan(text: 'Terms', onTap: () {});
      expect(span.style?.decoration, TextDecoration.underline);
      expect(span.style?.color, isNotNull);
    });

    testWidgets('renders text inside Text.rich', (tester) async {
      await pumpWidget(
        tester,
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'By continuing you agree to our '),
              LinkSpan(text: 'Terms', onTap: () {}),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      );
      expect(find.textContaining('Terms'), findsOneWidget);
    });
  });
}
