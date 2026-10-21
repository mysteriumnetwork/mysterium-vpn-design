import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Builds one hyperlink inside a [LinkText] paragraph.
typedef LinkBuilder = InlineSpan Function(String text, VoidCallback onTap);

/// A paragraph whose hyperlinks react to pointer and touch.
///
/// At rest a link inherits the paragraph's own colour and carries no
/// underline; while hovered or pressed it switches to
/// [Palette.textBrandPrimary] and gains an underline. Links are ordinary
/// [TextSpan]s, so a long one still wraps across lines rather than being
/// pushed down as an atomic block.
///
/// ```dart
/// LinkText(
///   style: theme.textStyles.textSm.regular.copyWith(color: palette.textSecondary),
///   builder: (link) => [
///     const TextSpan(text: 'By continuing you agree to our '),
///     link('Terms of Service', openTerms),
///     const TextSpan(text: '.'),
///   ],
/// )
/// ```
class LinkText extends StatefulWidget {
  const LinkText({required this.builder, this.style, this.textAlign, super.key});

  /// Builds the paragraph's spans. Call the supplied [LinkBuilder] for each
  /// hyperlink; everything else is an ordinary [TextSpan].
  ///
  /// Runs on every build, and must emit the same links in the same order each
  /// time — a link's identity is its position. Asserted in debug.
  final List<InlineSpan> Function(LinkBuilder link) builder;

  /// Style for the surrounding, non-link text.
  final TextStyle? style;

  /// Horizontal alignment of the paragraph.
  final TextAlign? textAlign;

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  final List<TapGestureRecognizer> _recognizers = [];
  int? _hovered;
  int? _pressed;
  int? _linkCount;

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  // Hover and press are tracked apart so a click doesn't drop the highlight
  // while the pointer is still on the link.
  void _setHovered(int? index) {
    if (mounted && _hovered != index) {
      setState(() => _hovered = index);
    }
  }

  void _setPressed(int? index) {
    if (mounted && _pressed != index) {
      setState(() => _pressed = index);
    }
  }

  InlineSpan _link(Palette palette, int index, String text, VoidCallback onTap) {
    // Indices are handed out densely and in order, so the pool is at most one short.
    if (index == _recognizers.length) {
      _recognizers.add(TapGestureRecognizer());
    }
    // The closures are parenthesised so each `..` cascades on the recognizer;
    // without them `..` binds to the preceding arrow body instead.
    final recognizer = _recognizers[index]
      ..onTap = onTap
      ..onTapDown = ((_) => _setPressed(index))
      ..onTapUp = ((_) => _setPressed(null))
      ..onTapCancel = (() => _setPressed(null));

    final active = _hovered == index || _pressed == index;

    return TextSpan(
      text: text,
      // At rest the colour is left unset so the paragraph's style shows through.
      style: active
          ? TextStyle(
              color: palette.textBrandPrimary,
              decoration: TextDecoration.underline,
              decorationColor: palette.textBrandPrimary,
            )
          : const TextStyle(decoration: TextDecoration.none),
      mouseCursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(index),
      onExit: (_) => _setHovered(null),
      recognizer: recognizer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).palette;
    var index = 0;
    final children = widget.builder((text, onTap) => _link(palette, index++, text, onTap));
    // A link emitted conditionally would shift every later link's state onto
    // the wrong word, silently. Fail loudly in debug instead.
    assert(
      _linkCount == null || _linkCount == index,
      'LinkText.builder must emit the same links in the same order on every '
      'build; it emitted $_linkCount before and $index now.',
    );
    _linkCount = index;
    return Text.rich(
      TextSpan(style: widget.style, children: children),
      textAlign: widget.textAlign,
    );
  }
}
