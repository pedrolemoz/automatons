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

  static thompsonConstruction(String regularExpression) {
    final regexScanner = RegExpScanner(regularExpression);
    final symbols = regexScanner.parse();
    List<EpsilonNFA> eNFAs = _generateNFAsFromSymbol(symbols, []);

    for (var e in eNFAs) {
      print(e.transitions);
    }
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

      eNFAs.add(eNFA);
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

    eNFAs.add(eNFA);
    return _generateNFAsFromSymbol(symbols, eNFAs, stateCounter);
  }

  @override
  bool evaluate(String input) {
    if (!hasValidInput(input)) return false;
    final eClosure = epsilonClosure(initialState);
    final states = eClosure.map((cState) => extendedTransition(cState, input)).reduce((a, b) => a += b);
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
    return [state] + possibleNextStates.map((nextState) => epsilonClosure(nextState)).reduce((a, b) => a += b);
  }
}
