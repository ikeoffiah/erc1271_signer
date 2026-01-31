import '../concat.dart';
import '../encoding.dart';
import '../pad.dart';

/// Packed ABI encoding (no padding between elements).
/// bytes32 = 32 bytes, uint8 = 1 byte → total 65 bytes for (bytes32, bytes32, uint8).
String encodePacked(List<String> types, List<dynamic> values) {
  if (types.length != values.length) throw ArgumentError('Length mismatch');
  final parts = <String>[];
  for (int i = 0; i < types.length; i++) {
    final t = types[i];
    final v = values[i];
    if (t == 'bytes32') {
      parts.add(padHex(_toHex(v), size: 32));
    } else if (t == 'uint8') {
      final n = v is BigInt ? v : BigInt.from(v as int);
      // Packed: uint8 is 1 byte only (no 32-byte padding)
      parts.add(numberToHex(n, size: 1));
    } else {
      throw UnimplementedError('Packed type: $t');
    }
  }
  return concatHex(parts);
}

String _toHex(dynamic v) {
  if (v is String) return v.startsWith('0x') ? v : '0x$v';
  if (v is BigInt) return numberToHex(v, size: 32);
  return numberToHex(BigInt.from(v as int), size: 32);
}
