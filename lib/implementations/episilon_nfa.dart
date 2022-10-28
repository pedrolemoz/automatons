import '../abstractions/constants.dart';
import '../abstractions/epsilon_non_deterministic_automaton.dart';
import '../abstractions/regular_expressions.dart';
import '../utils/index_extension.dart';

class EpsilonNFA extends EpsilonNonDeterministicAutomaton {
  const EpsilonNFA({
    required super.states,
    required super.alphabet,
    required super.transitions,
    required super.initialState,
    required super.finalStates,
  });

  static thompsonConstruction(String regularExpression) {
    final symbols = _parseRegularExpression(regularExpression, []);
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

  static List<Symbol> _parseRegularExpression(String regularExpression, List<Symbol> symbols) {
    if (regularExpression.isEmpty) return symbols;

    final symbol = regularExpression[0];

    if (symbol == '(') {
      int offset = 0;

      for (var i = 1; i < regularExpression.length; i++) {
        final element = regularExpression[i];
        if (element == ')') break;
        if (element == '(') offset++;
      }

      final closeParenthesisIndexes = regularExpression.allIndexesOf(')');
      final closeParenthesisIndex = closeParenthesisIndexes[offset];
      final selectionSymbols = _parseRegularExpression(regularExpression.substring(1, closeParenthesisIndex), []);
      List<Symbol> left = [];
      List<Symbol> right = [];

      if (selectionSymbols.any((symbol) => symbol is ConcatenationSymbol)) {
        final selectionSymbolIndex = selectionSymbols.indexWhere((symbol) => symbol is ConcatenationSymbol);
        left = selectionSymbols.sublist(0, selectionSymbolIndex);
        right = selectionSymbols.sublist(selectionSymbolIndex + 1, selectionSymbols.length);
      }

      final hasConcatenation = left.isNotEmpty && right.isNotEmpty;

      if (regularExpression.length > closeParenthesisIndex + 1 && regularExpression[closeParenthesisIndex + 1] == '*') {
        if (hasConcatenation) {
          symbols.add(KleenClosure([Concatenation(left: left, right: right)]));
        } else {
          symbols.add(KleenClosure(selectionSymbols));
        }

        return _parseRegularExpression(regularExpression.substring(closeParenthesisIndex + 2), symbols);
      } else {
        if (hasConcatenation) {
          symbols.add(Selection([Concatenation(left: left, right: right)]));
        } else {
          symbols.add(Selection(selectionSymbols));
        }

        return _parseRegularExpression(regularExpression.substring(closeParenthesisIndex + 1), symbols);
      }
    }

    if (symbol == 'ε') {
      symbols.add(const Epsilon());
      return _parseRegularExpression(regularExpression.substring(1), symbols);
    }

    if (symbol == '+') {
      symbols.add(const ConcatenationSymbol());
      return _parseRegularExpression(regularExpression.substring(1), symbols);
    }

    if (regularExpression.length > 2 && regularExpression[1] == '*') {
      symbols.add(KleenClosure([Literal(symbol)]));
      return _parseRegularExpression(regularExpression.substring(2), symbols);
    } else {
      symbols.add(Literal(symbol));
      return _parseRegularExpression(regularExpression.substring(1), symbols);
    }
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
