import 'package:test/test.dart';

import 'package:automatons/implementations/dfa.dart';

void main() {
  group('DFA over the set {a, b} that contains the substring "aabb"', () {
    final dfa1 = const DFA(
      states: ['q0', 'q1', 'q2', 'q3', 'q4'],
      initialState: 'q0',
      finalStates: ['q4'],
      alphabet: ['a', 'b'],
      transitions: {
        'q0': {'a': 'q1', 'b': 'q0'},
        'q1': {'a': 'q2', 'b': 'q0'},
        'q2': {'a': 'q2', 'b': 'q3'},
        'q3': {'a': 'q1', 'b': 'q4'},
        'q4': {'a': 'q4', 'b': 'q4'},
      },
    );
    test('Should accept the string "aabb"', () {
      final result = dfa1.evaluate('aabb');
      expect(result, true);
    });
    test('Should accept the string "aaabb"', () {
      final result = dfa1.evaluate('aaabb');
      expect(result, true);
    });
    test('Should accept the string "aaabbb"', () {
      final result = dfa1.evaluate('aaabbb');
      expect(result, true);
    });
    test('Should accept the string "aaaababbbaaabb"', () {
      final result = dfa1.evaluate('aaaababbbaaabb');
      expect(result, true);
    });
    test('Should accept the string "ababaababbbbaaabba"', () {
      final result = dfa1.evaluate('ababaababbbbaaabba');
      expect(result, true);
    });
    test('Should reject the empty string', () {
      final result = dfa1.evaluate('');
      expect(result, false);
    });
    test('Should reject the string "a"', () {
      final result = dfa1.evaluate('a');
      expect(result, false);
    });
    test('Should reject the string "ab"', () {
      final result = dfa1.evaluate('ab');
      expect(result, false);
    });
    test('Should reject the string "ba"', () {
      final result = dfa1.evaluate('ba');
      expect(result, false);
    });
    test('Should reject the string "bab"', () {
      final result = dfa1.evaluate('bab');
      expect(result, false);
    });
    test('Should reject the string "baba"', () {
      final result = dfa1.evaluate('baba');
      expect(result, false);
    });
    test('Should reject the string "b"', () {
      final result = dfa1.evaluate('b');
      expect(result, false);
    });
    test('Should reject the string "abab"', () {
      final result = dfa1.evaluate('abab');
      expect(result, false);
    });
    test('Should reject the string "bbaa"', () {
      final result = dfa1.evaluate('bbaa');
      expect(result, false);
    });
    test('Should reject the string "abababbababbbab"', () {
      final result = dfa1.evaluate('abababbababbbab');
      expect(result, false);
    });
  });

  group('DFA over the set {a, b} that does not contains the substring "aabb"', () {
    final dfa2 = const DFA(
      states: ['q0', 'q1', 'q2', 'q3', 'q4'],
      initialState: 'q0',
      finalStates: ['q0', 'q1', 'q2', 'q3'],
      alphabet: ['a', 'b'],
      transitions: {
        'q0': {'a': 'q1', 'b': 'q0'},
        'q1': {'a': 'q2', 'b': 'q0'},
        'q2': {'a': 'q2', 'b': 'q3'},
        'q3': {'a': 'q1', 'b': 'q4'},
        'q4': {'a': 'q4', 'b': 'q4'},
      },
    );

    test('Should reject the string "aabb"', () {
      final result = dfa2.evaluate('aabb');
      expect(result, false);
    });
    test('Should reject the string "aaabb"', () {
      final result = dfa2.evaluate('aaabb');
      expect(result, false);
    });
    test('Should reject the string "aaabbb"', () {
      final result = dfa2.evaluate('aaabbb');
      expect(result, false);
    });
    test('Should reject the string "aaaababbbaaabb"', () {
      final result = dfa2.evaluate('aaaababbbaaabb');
      expect(result, false);
    });
    test('Should reject the string "ababaababbbbaaabba"', () {
      final result = dfa2.evaluate('ababaababbbbaaabba');
      expect(result, false);
    });
    test('Should accept the empty string', () {
      final result = dfa2.evaluate('');
      expect(result, true);
    });
    test('Should accept the string "a"', () {
      final result = dfa2.evaluate('a');
      expect(result, true);
    });
    test('Should accept the string "ab"', () {
      final result = dfa2.evaluate('ab');
      expect(result, true);
    });
    test('Should accept the string "ba"', () {
      final result = dfa2.evaluate('ba');
      expect(result, true);
    });
    test('Should accept the string "bab"', () {
      final result = dfa2.evaluate('bab');
      expect(result, true);
    });
    test('Should accept the string "baba"', () {
      final result = dfa2.evaluate('baba');
      expect(result, true);
    });
    test('Should accept the string "b"', () {
      final result = dfa2.evaluate('b');
      expect(result, true);
    });
    test('Should accept the string "abab"', () {
      final result = dfa2.evaluate('abab');
      expect(result, true);
    });
    test('Should accept the string "bbaa"', () {
      final result = dfa2.evaluate('bbaa');
      expect(result, true);
    });
    test('Should accept the string "abababbababbbab"', () {
      final result = dfa2.evaluate('abababbababbbab');
      expect(result, true);
    });
  });
}
