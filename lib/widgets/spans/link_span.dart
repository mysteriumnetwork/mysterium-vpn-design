import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/styles/colors/palette.dart';

class LinkSpan extends TextSpan {
  LinkSpan({
    required String text,
    required VoidCallback onTap,
    TextStyle? style,
  }) : super(
          text: text,
          style: style?.copyWith(
                color: style.color ?? Palette.brand,
                decoration: TextDecoration.underline,
              ) ??
              const TextStyle(
                color: Palette.brand,
                decoration: TextDecoration.underline,
              ),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        );
}
