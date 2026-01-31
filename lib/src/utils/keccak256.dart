import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:convert/convert.dart';

/// Keccak-256 hash (Ethereum's pre-NIST keccak).
/// Returns hex string with "0x" prefix.
String keccak256Hex(List<int> bytes) {
  final digest = keccak256.convert(bytes);
  return '0x${hex.encode(digest.bytes)}';
}

/// Keccak-256 hash, returns raw bytes.
Uint8List keccak256Bytes(List<int> bytes) {
  final digest = keccak256.convert(bytes);
  return Uint8List.fromList(digest.bytes);
}
