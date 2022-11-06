import 'dart:convert';

import '../abstractions/constants.dart';
import '../abstractions/epsilon_non_deterministic_automaton.dart';
import '../abstractions/regular_expression_scanner.dart';
import 'regexp_scanner.dart';

class EpsilonNFA extends EpsilonNonDeterministicAutomaton {
  const EpsilonNFA({
    required super.states,
    required super.alphabet,
    required super.transitions,
    required super.initialState,
    required super.finalStates,
  });

  static dynamic thompsonConstruction(String regularExpression) {
    final regexScanner = RegExpScanner(regularExpression);
    final symbols = regexScanner.parse();
    List<EpsilonNFA> eNFAs = _generateNFAsFromSymbol(symbols, []);
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    return eNFAs;
    // for (var e in eNFAs) {
    //   print('Initial state ${e.initialState}\n');
    //   print('Final states ${e.finalStates}\n');
    //   print(encoder.convert(e.transitions));
    //   print(e.evaluate('ab'));
    // }
  }

  static List<EpsilonNFA> _generateNFAsFromSymbol(
    List<Symbol> symbols,
    List<EpsilonNFA> eNFAs, [
    int stateCounter = 0,
  ]) {
    if (symbols.isEmpty) return eNFAs;

    final element = symbols.removeAt(0);

    if (element is Literal) {
      final firstState = 'q$stateCounter';
      final lastState = 'q${stateCounter + 1}';

      stateCounter += 2;

      final eNFA = EpsilonNFA(
        states: [firstState, lastState],
        initialState: firstState,
        alphabet: [element.symbol],
        transitions: {
          firstState: {
            element.symbol: [lastState]
          },
          lastState: {}
        },
        finalStates: [lastState],
      );

      if (eNFAs.isNotEmpty) {
        final lastNFA = eNFAs.removeLast();

        eNFAs.add(_eNFAConcatenation(eNFA, lastNFA));
      } else {
        eNFAs.add(eNFA);
      }

      return _generateNFAsFromSymbol(symbols, eNFAs, stateCounter);
    }

    // if (element is Union) {
    //   if (eNFAs.isNotEmpty) {
    //     final firstUnionState = 'q$stateCounter';
    //     final lastUnionState = 'q${stateCounter + 1}';

    //     final lastNFA = eNFAs.removeLast();

    //     eNFAs.add(
    //       EpsilonNFA(
    //         states: [...eNFA.states, ...lastNFA.states, firstUnionState, lastUnionState],
    //         alphabet: [...eNFA.alphabet, ...lastNFA.alphabet],
    //         transitions: {
    //           firstUnionState: {
    //             epsilon: [
    //               eNFA.initialState,
    //               lastNFA.initialState,
    //             ],
    //           },
    //           ...eNFA.transitions,
    //           ...lastNFA.transitions,
    //           for (var state in eNFA.finalStates) ...{
    //             state: {
    //               epsilon: [lastUnionState]
    //             },
    //           },
    //           for (var state in lastNFA.finalStates) ...{
    //             state: {
    //               epsilon: [lastUnionState]
    //             },
    //           },
    //           lastUnionState: {}
    //         },
    //         initialState: firstUnionState,
    //         finalStates: [lastUnionState],
    //       ),
    //     );
    //   }
    // }

    if (element is Selection) {
      final eNFAsSelection =
          _generateNFAsFromSymbol(element.symbols, [], stateCounter);

      eNFAs.addAll(eNFAsSelection);
      return _generateNFAsFromSymbol(symbols, eNFAs, stateCounter);
    }

    final firstState = 'q$stateCounter';
    final lastState = 'q${stateCounter + 1}';

    stateCounter += 2;

    final eNFA = EpsilonNFA(
      states: [firstState, lastState],
      initialState: firstState,
      alphabet: [],
      transitions: {
        firstState: {
          epsilon: [lastState]
        },
        lastState: {}
      },
      finalStates: [lastState],
    );

    if (eNFAs.isNotEmpty) {
      final lastNFA = eNFAs.removeLast();

      eNFAs.add(_eNFAConcatenation(eNFA, lastNFA));
    } else {
      eNFAs.add(eNFA);
    }

    return _generateNFAsFromSymbol(symbols, eNFAs, stateCounter);
  }

  static EpsilonNFA _eNFAConcatenation(
      EpsilonNFA currentNFA, EpsilonNFA lastNFA) {
    for (var state in lastNFA.finalStates) {
      if (lastNFA.transitions[state]?[epsilon] != null) {
        lastNFA.transitions[state]![epsilon]!.add(currentNFA.initialState);
      } else {
        lastNFA.transitions[state]?.addAll({
          epsilon: [currentNFA.initialState]
        });
      }
    }

    return EpsilonNFA(
      states: [...lastNFA.states, ...currentNFA.states],
      alphabet: [...lastNFA.alphabet, ...currentNFA.alphabet],
      transitions: {...lastNFA.transitions, ...currentNFA.transitions},
      initialState: lastNFA.initialState,
      finalStates: [...currentNFA.finalStates],
    );
  }

  @override
  bool evaluate(String input) {
    if (!hasValidInput(input)) return false;
    final eClosure = epsilonClosure(initialState);
    final states = eClosure
        .map((cState) => extendedTransition(cState, input))
        .reduce((a, b) => a += b);
    return states.any((state) => finalStates.contains(state));
  }

  @override
  List<String> extendedTransition(String state, String input) {
    if (input.isEmpty) return [state];
    final possibleNextStates = transitions[state]![input[0]];
    if (possibleNextStates == null) return [];
    return possibleNextStates
        .map((nextState) => epsilonClosure(nextState)
            .map((cState) => extendedTransition(cState, input.substring(1)))
            .reduce((a, b) => a += b))
        .reduce((a, b) => a += b);
  }

  @override
  List<String> epsilonClosure(String state) {
    if (!transitions[state]!.containsKey(epsilon)) return [state];
    final possibleNextStates = transitions[state]![epsilon]!;
    return [state] +
        possibleNextStates
            .map((nextState) => epsilonClosure(nextState))
            .reduce((a, b) => a += b);
  }
}
