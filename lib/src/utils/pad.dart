/// Pad hex to [size] bytes (default 32), left-padded with zeros.
String padHex(String hexStr, {int size = 32, bool right = false}) {
  final s = hexStr.startsWith('0x') ? hexStr.substring(2) : hexStr;
  final byteLen = (s.length / 2).ceil();
  if (size != 0 && byteLen > size) {
    throw ArgumentError('Size $byteLen exceeds padding size $size');
  }
  if (size == 0) return hexStr.startsWith('0x') ? hexStr : '0x$hexStr';
  final targetLen = size * 2;
  final padded = right ? s.padRight(targetLen, '0') : s.padLeft(targetLen, '0');
  return '0x$padded';
}

/// Pad bytes to [size], left (or right) with zeros.
List<int> padBytes(List<int> bytes, {int size = 32, bool right = false}) {
  if (size != 0 && bytes.length > size) {
    throw ArgumentError('Size ${bytes.length} exceeds padding size $size');
  }
  if (size == 0) return List.from(bytes);
  final result = List<int>.filled(size, 0);
  if (right) {
    for (int i = 0; i < bytes.length; i++) result[i] = bytes[i];
  } else {
    final offset = size - bytes.length;
    for (int i = 0; i < bytes.length; i++) result[offset + i] = bytes[i];
  }
  return result;
}
