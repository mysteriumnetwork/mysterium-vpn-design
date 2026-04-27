import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/styles/colors/palette.dart';

/// A [TextSpan] styled as an inline hyperlink.
///
/// Renders `text` underlined in the brand colour and wires `onTap` via a
/// `TapGestureRecognizer`. Pass `style` to override the defaults — the
/// colour and underline are preserved if not explicitly unset.
class LinkSpan extends TextSpan {
  LinkSpan({required String text, required VoidCallback onTap, TextStyle? style})
    : super(
        text: text,
        style:
            style?.copyWith(
              color: style.color ?? Palette.brand,
              decoration: TextDecoration.underline,
            ) ??
            const TextStyle(color: Palette.brand, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()..onTap = onTap,
      );
}
