import '../abstractions/deterministic_automaton.dart';

class DFA extends DeterministicAutomaton {
  const DFA({
    required super.states,
    required super.alphabet,
    required super.transitions,
    required super.initialState,
    required super.finalStates,
  });

  @override
  bool evaluate(String input) {
    if (!hasValidInput(input)) return false;
    final state = extendedTransition(initialState, input);
    return finalStates.contains(state);
  }

  @override
  String extendedTransition(String state, String input) {
    if (input.isEmpty) return state;
    return extendedTransition(
      transitions[state]![input[0]]!,
      input.substring(1),
    );
  }
}
