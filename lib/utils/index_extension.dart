extension IndexExtension on String {
  List<int> allIndexesOf(String element, [int start = 0, int? end]) {
    List<int> indexes = [];
    final maxLength = end ?? this.length;

    for (var i = start; i < maxLength; i++) {
      if (element == this[i]) {
        indexes.add(i);
      }
    }

    return indexes;
  }
}
