import 'automaton.dart';

abstract class NonDeterministicAutomaton extends Automaton<List<String>> {
  const NonDeterministicAutomaton({
    required super.states,
    required super.alphabet,
    required super.transitions,
    required super.initialState,
    required super.finalStates,
  });
}
