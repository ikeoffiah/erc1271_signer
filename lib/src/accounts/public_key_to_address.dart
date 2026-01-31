import 'package:convert/convert.dart';
import 'package:web3dart/crypto.dart';

import '../utils/keccak256.dart';

/// Ethereum address from public key (uncompressed 65 bytes hex).
/// Uses Keccak-256 (Ethereum) not SHA3; web3dart's publicKeyToAddress may use SHA3.
String publicKeyToAddressHex(String publicKeyHex) {
  final pk =
      publicKeyHex.startsWith('0x') ? publicKeyHex.substring(2) : publicKeyHex;
  if (pk.length != 130) {
    throw ArgumentError('Expected 65-byte uncompressed public key (130 hex)');
  }
  final pubKeyBytes = hexToBytes(publicKeyHex);
  // Ethereum: keccak256(pubkey[1:33]) then last 20 bytes
  final toHash = pubKeyBytes.sublist(1); // skip 0x04
  final hash = keccak256Bytes(toHash);
  final addressBytes = hash.sublist(12, 32); // last 20 bytes
  return '0x${hex.encode(addressBytes).toLowerCase()}';
}
