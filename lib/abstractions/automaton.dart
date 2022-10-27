abstract class Automaton<TransitionsType> {
  final List<String> states;
  final List<String> alphabet;
  final Map<String, Map<String, TransitionsType>> transitions;
  final String initialState;
  final List<String> finalStates;

  const Automaton({
    required this.states,
    required this.alphabet,
    required this.transitions,
    required this.initialState,
    required this.finalStates,
  });

  bool hasValidInput(String input) {
    final symbols = input.split('');
    return symbols.every((symbol) => alphabet.contains(symbol));
  }

  bool evaluate(String input);

  TransitionsType extendedTransition(String state, String input);
}
