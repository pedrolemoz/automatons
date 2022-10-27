import 'implementations/episilon_nfa.dart';

void main() {
  // final regularExpression = '(0+10)*(11+ε)(0+10)*';
  final regularExpression = 'abc';
  EpsilonNFA.thompsonConstruction(regularExpression);
}
