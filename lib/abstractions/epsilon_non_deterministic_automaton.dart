import 'non_deterministic_automaton.dart';

abstract class EpsilonNonDeterministicAutomaton
    extends NonDeterministicAutomaton {
  const EpsilonNonDeterministicAutomaton({
    required super.states,
    required super.alphabet,
    required super.transitions,
    required super.initialState,
    required super.finalStates,
  });

  List<String> epsilonClosure(String state);
}
