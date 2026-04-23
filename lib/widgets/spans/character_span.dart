import 'package:flutter/widgets.dart';

/// Convenience [TextSpan]s for common single-character runs used to stitch
/// together rich-text fragments without string concatenation.
///
/// All factories accept an optional [TextStyle] so the character can pick
/// up surrounding context (e.g. colour, weight).
class CharacterSpan extends TextSpan {
  const CharacterSpan._({required String character, super.style}) : super(text: character);

  /// A single space (` `).
  factory CharacterSpan.space({TextStyle? style}) => CharacterSpan._(character: ' ', style: style);

  /// A newline (`\n`).
  factory CharacterSpan.newline({TextStyle? style}) =>
      CharacterSpan._(character: '\n', style: style);

  /// A forward slash (`/`).
  factory CharacterSpan.slash({TextStyle? style}) => CharacterSpan._(character: '/', style: style);

  /// A hyphen (`-`).
  factory CharacterSpan.hyphen({TextStyle? style}) => CharacterSpan._(character: '-', style: style);

  /// A percent sign (`%`).
  factory CharacterSpan.percent({TextStyle? style}) =>
      CharacterSpan._(character: '%', style: style);

  /// A bullet point (`•`).
  factory CharacterSpan.bullet({TextStyle? style}) => CharacterSpan._(character: '•', style: style);
}
