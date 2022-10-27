import 'package:test/test.dart';

import 'package:automatons/abstractions/constants.dart';
import 'package:automatons/implementations/episilon_nfa.dart';

void main() {
  final eNfa = const EpsilonNFA(
    states: ['q0', 'q1' 'q2', 'q3', 'q4', 'q5', 'q6', 'q7'],
    initialState: 'q0',
    finalStates: ['q4', 'q7'],
    alphabet: ['a', 'b', 'c'],
    transitions: {
      'q0': {
        epsilon: ['q1', 'q5'],
      },
      'q1': {
        'a': ['q2'],
      },
      'q2': {
        'b': ['q3'],
      },
      'q3': {
        'c': ['q4'],
      },
      'q4': {},
      'q5': {
        'a': ['q5'],
        'b': ['q5'],
        'c': ['q5', 'q6'],
      },
      'q6': {
        'c': ['q7'],
      },
      'q7': {},
    },
  );

  group('eNFA over the set {a, b, c} that is exactly the substring "abc" or ends with the substring "cc"', () {
    test('Should accept the string "abc"', () {
      final result = eNfa.evaluate('abc');
      expect(result, true);
    });
    test('Should accept the string "cc"', () {
      final result = eNfa.evaluate('cc');
      expect(result, true);
    });
    test('Should accept the string "abccc"', () {
      final result = eNfa.evaluate('abccc');
      expect(result, true);
    });
    test('Should accept the string "aabbcc"', () {
      final result = eNfa.evaluate('aabbcc');
      expect(result, true);
    });
    test('Should accept the string "bbaacc"', () {
      final result = eNfa.evaluate('bbaacc');
      expect(result, true);
    });
    test('Should accept the string "cccccc"', () {
      final result = eNfa.evaluate('cccccc');
      expect(result, true);
    });
    test('Should accept the string "abababacc"', () {
      final result = eNfa.evaluate('abababacc');
      expect(result, true);
    });
    test('Should accept the string "cbcbcbccc"', () {
      final result = eNfa.evaluate('cbcbcbccc');
      expect(result, true);
    });
    test('Should reject the empty string', () {
      final result = eNfa.evaluate('');
      expect(result, false);
    });
    test('Should reject the string "abca"', () {
      final result = eNfa.evaluate('abca');
      expect(result, false);
    });
    test('Should reject the string "a"', () {
      final result = eNfa.evaluate('a');
      expect(result, false);
    });
    test('Should reject the string "b"', () {
      final result = eNfa.evaluate('b');
      expect(result, false);
    });
    test('Should reject the string "c"', () {
      final result = eNfa.evaluate('c');
      expect(result, false);
    });
    test('Should reject the string "aa"', () {
      final result = eNfa.evaluate('aa');
      expect(result, false);
    });
    test('Should reject the string "bb"', () {
      final result = eNfa.evaluate('bb');
      expect(result, false);
    });
    test('Should reject the string "aba"', () {
      final result = eNfa.evaluate('aba');
      expect(result, false);
    });
    test('Should reject the string "abaaabb"', () {
      final result = eNfa.evaluate('abaaabb');
      expect(result, false);
    });
    test('Should reject the string "bbabbabbabbbacca"', () {
      final result = eNfa.evaluate('bbabbabbabbbacca');
      expect(result, false);
    });
    test('Should reject the string "babacabacaba"', () {
      final result = eNfa.evaluate('babacabacaba');
      expect(result, false);
    });
  });
}
