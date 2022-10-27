import 'automaton.dart';

abstract class DeterministicAutomaton extends Automaton<String> {
  const DeterministicAutomaton({
    required super.states,
    required super.alphabet,
    required super.transitions,
    required super.initialState,
    required super.finalStates,
  });
}
