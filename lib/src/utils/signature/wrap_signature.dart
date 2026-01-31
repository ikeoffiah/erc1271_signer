import '../abi/encode_abi_parameters.dart';
import '../abi/encode_packed.dart';
import '../concat.dart';
import '../data_size.dart';
import '../encoding.dart';
import 'parse_signature.dart';

/// Wrap owner signature for Coinbase Smart Wallet: (ownerIndex, signatureData).
/// single-tuple encoding has leading offset word (32),
/// then tuple (ownerIndex, offset, length, data).
String wrapSignature({int ownerIndex = 0, required String signature}) {
  String signatureData = signature;
  if (dataSize(signature) == 65) {
    final parsed = parseSignature(signature);
    final v = parsed.yParity == 0 ? 27 : 28;
    signatureData = encodePacked(
      ['bytes32', 'bytes32', 'uint8'],
      [parsed.r, parsed.s, BigInt.from(v)],
    );
  }
  final tupleEncoded = encodeAbiParameters(
    [
      {'name': 'ownerIndex', 'type': 'uint8'},
      {'name': 'signatureData', 'type': 'bytes'},
    ],
    [BigInt.from(ownerIndex), signatureData],
  );
  // encodes a single tuple as [offset_to_tuple_data=32][tuple_data]; prepend so layout matches
  return concatHex([numberToHex(BigInt.from(32), size: 32), tupleEncoded]);
}
