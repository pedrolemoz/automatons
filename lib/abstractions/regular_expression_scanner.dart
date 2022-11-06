abstract class RegularExpressionScanner {
  const RegularExpressionScanner();

  List<Symbol> parse();
}

abstract class Symbol {}

class Epsilon implements Symbol {
  final String symbol = 'ε';

  const Epsilon();

  @override
  String toString() => '$runtimeType => $symbol';
}

class Or implements Symbol {
  final String symbol = '+';

  const Or();

  @override
  String toString() => '$runtimeType => $symbol';
}

class Union implements Symbol {
  final List<Symbol> left;
  final List<Symbol> right;

  const Union({required this.left, required this.right});

  @override
  String toString() => '$runtimeType => $left || $right';
}

class Literal implements Symbol {
  final String symbol;

  const Literal(this.symbol);

  @override
  String toString() => '$runtimeType => $symbol';
}

class Selection implements Symbol {
  final List<Symbol> symbols;

  const Selection(this.symbols);

  @override
  String toString() => '$runtimeType => $symbols';
}

class Range implements Symbol {
  final List<Symbol> symbols;

  const Range(this.symbols);

  @override
  String toString() => '$runtimeType => $symbols';
}

class KleenClosure implements Symbol {
  final List<Symbol> symbols;

  const KleenClosure(this.symbols);

  @override
  String toString() => '$runtimeType => $symbols';
}
