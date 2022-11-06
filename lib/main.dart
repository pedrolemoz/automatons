import 'implementations/regexp_scanner.dart';

void main() {
  final regularExpression = '(0+10)*(11+ε)(0+10)*';
  final regexScanner = RegExpScanner(regularExpression);
  final list = regexScanner.parse();
  for (var i in list) print(i);
}
