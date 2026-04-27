import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

void main() {
  group('CharacterSpan', () {
    test('space factory produces a single space', () {
      expect(CharacterSpan.space().text, equals(' '));
    });

    test('newline factory produces a newline', () {
      expect(CharacterSpan.newline().text, equals('\n'));
    });

    test('slash factory produces a forward slash', () {
      expect(CharacterSpan.slash().text, equals('/'));
    });

    test('hyphen factory produces a hyphen', () {
      expect(CharacterSpan.hyphen().text, equals('-'));
    });

    test('percent factory produces a percent sign', () {
      expect(CharacterSpan.percent().text, equals('%'));
    });

    test('bullet factory produces a bullet', () {
      expect(CharacterSpan.bullet().text, equals('•'));
    });
  });
}
