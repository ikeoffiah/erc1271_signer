/// Size of hex or bytes in bytes.
int dataSize(dynamic value) {
  if (value is String) {
    final h = value.startsWith('0x') ? value.substring(2) : value;
    return (h.length / 2).ceil();
  }
  if (value is List<int>) return value.length;
  throw ArgumentError('Expected hex string or bytes');
}

bool isHex(String value, {bool strict = true}) {
  final s = value.startsWith('0x') ? value.substring(2) : value;
  if (s.isEmpty) return !strict;
  return RegExp(r'^[0-9a-fA-F]+$').hasMatch(s);
}
