import 'dart:convert';

import 'package:convert/convert.dart';

/// Encode string to hex with 0x prefix (UTF-8 bytes).
String stringToHex(String s) {
  final bytes = utf8.encode(s);
  return '0x${hex.encode(bytes)}';
}

/// Ensure hex has 0x prefix.
String toHex(String hexStr) {
  if (hexStr.startsWith('0x')) return hexStr;
  return '0x$hexStr';
}

/// Encode integer as hex with optional byte size (left-padded).
String numberToHex(BigInt value, {int size = 32}) {
  if (value < BigInt.zero) throw ArgumentError('Negative not supported');
  String h = value.toRadixString(16);
  if (h.length.isOdd) h = '0$h';
  if (size != 0) {
    final targetLen = size * 2;
    if (h.length > targetLen) throw ArgumentError('Value exceeds size');
    h = h.padLeft(targetLen, '0');
  }
  return '0x$h';
}
