/// Concatenate hex strings (strips 0x from each).
String concatHex(List<String> values) {
  final parts =
      values.map((x) => x.startsWith('0x') ? x.substring(2) : x).toList();
  return '0x${parts.join('')}';
}

/// Concatenate byte lists.
List<int> concatBytes(List<List<int>> values) {
  return values.expand((x) => x).toList();
}
