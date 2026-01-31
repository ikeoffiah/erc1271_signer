import 'dart:convert';

import '../concat.dart';
import '../keccak256.dart';
import 'encode_abi_parameters.dart';

/// Function selector: first 4 bytes of keccak256(signature).
String toFunctionSelector(String signature) {
  final bytes = utf8.encode(signature);
  final hash = keccak256Hex(bytes).substring(2);
  return '0x${hash.substring(0, 8)}';
}

/// Encode function call: selector + encodeAbiParameters(args).
String encodeFunctionData({
  required String abiFunctionSignature,
  required List<Map<String, dynamic>> args,
  required List<dynamic> values,
}) {
  final selector = toFunctionSelector(abiFunctionSignature);
  final encoded = encodeAbiParameters(args, values);
  return concatHex([selector, encoded]);
}

/// getAddress(bytes[],uint256) encoding for factory.
String encodeGetAddress(List<String> ownersBytes, BigInt nonce) {
  return encodeFunctionData(
    abiFunctionSignature: 'getAddress(bytes[],uint256)',
    args: [
      {'type': 'bytes[]'},
      {'type': 'uint256'},
    ],
    values: [ownersBytes, nonce],
  );
}
