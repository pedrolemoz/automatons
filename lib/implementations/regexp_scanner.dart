import '../abstractions/regular_expression_scanner.dart';
import '../utils/index_extension.dart';

class RegExpScanner implements RegularExpressionScanner {
  final String regularExpression;

  const RegExpScanner(this.regularExpression);

  @override
  List<Symbol> parse() => _parseRegularExpression("($regularExpression)", []);

  List<Symbol> _parseRegularExpression(
    String regularExpression,
    List<Symbol> symbols,
  ) {
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
      final selectionSymbols = _parseRegularExpression(
        regularExpression.substring(1, closeParenthesisIndex),
        [],
      );
      List<Symbol> left = [];
      List<Symbol> right = [];

      if (selectionSymbols.any((symbol) => symbol is Or)) {
        final selectionSymbolIndex =
            selectionSymbols.indexWhere((symbol) => symbol is Or);
        left = selectionSymbols.sublist(0, selectionSymbolIndex);
        right = selectionSymbols.sublist(
            selectionSymbolIndex + 1, selectionSymbols.length);
      }

      final hasUnion = left.isNotEmpty && right.isNotEmpty;

      if (regularExpression.length > closeParenthesisIndex + 1 &&
          regularExpression[closeParenthesisIndex + 1] == '*') {
        if (hasUnion) {
          symbols.add(KleenClosure([Union(left: left, right: right)]));
        } else {
          symbols.add(KleenClosure(selectionSymbols));
        }

        return _parseRegularExpression(
          regularExpression.substring(closeParenthesisIndex + 2),
          symbols,
        );
      } else {
        if (hasUnion) {
          symbols.add(Selection([Union(left: left, right: right)]));
        } else {
          symbols.add(Selection(selectionSymbols));
        }

        return _parseRegularExpression(
          regularExpression.substring(closeParenthesisIndex + 1),
          symbols,
        );
      }
    }

    if (symbol == 'ε') {
      symbols.add(const Epsilon());
      return _parseRegularExpression(regularExpression.substring(1), symbols);
    }

    if (symbol == '+') {
      symbols.add(const Or());
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
}
