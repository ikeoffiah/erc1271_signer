import 'package:web3dart/crypto.dart';

import '../utils/pad.dart';

/// Sign a hash (32 bytes hex) with private key. Returns signature hex: 0x + r(64) + s(64) + v(2).
Future<String> signHash(String hashHex, String privateKeyHex) async {
  final hash = hexToBytes(hashHex);
  final pk = hexToBytes(privateKeyHex);
  if (hash.length != 32) throw ArgumentError('Hash must be 32 bytes');
  if (pk.length != 32) throw ArgumentError('Private key must be 32 bytes');
  final sig = sign(hash, pk);
  final r =
      padHex(bytesToHex(unsignedIntToBytes(sig.r), include0x: false), size: 32);
  final s =
      padHex(bytesToHex(unsignedIntToBytes(sig.s), include0x: false), size: 32);
  final v = sig.v & 0xFF;
  return '0x${r.substring(2)}${s.substring(2)}${v.toRadixString(16).padLeft(2, '0')}';
}
