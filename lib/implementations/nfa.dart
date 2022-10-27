import '../abstractions/non_deterministic_automaton.dart';

class NFA extends NonDeterministicAutomaton {
  const NFA({
    required super.states,
    required super.alphabet,
    required super.transitions,
    required super.initialState,
    required super.finalStates,
  });

  @override
  bool evaluate(String input) {
    if (!hasValidInput(input)) return false;
    final states = extendedTransition(initialState, input);
    return states.any((state) => finalStates.contains(state));
  }

  @override
  List<String> extendedTransition(String state, String input) {
    if (input.isEmpty) return [state];
    final possibleNextStates = transitions[state]![input[0]];
    if (possibleNextStates == null) return [];
    return possibleNextStates
        .map((nextState) => extendedTransition(nextState, input.substring(1)))
        .reduce((a, b) => a += b);
  }
}
