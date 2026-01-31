import '../utils/signature/hash_typed_data.dart';
import 'sign.dart';

/// Sign EIP-712 typed data hash. Returns signature hex.
Future<String> signTypedData({
  required int chainId,
  required String name,
  required String verifyingContract,
  required String version,
  required String hash,
  required String privateKeyHex,
}) async {
  final typedDataHash = hashTypedData(
    chainId: chainId,
    name: name,
    verifyingContract: verifyingContract,
    version: version,
    hash: hash,
  );
  return signHash(typedDataHash, privateKeyHex);
}

Future<String> signTypedDataWithKey({
  required int chainId,
  required String name,
  required String verifyingContract,
  required String version,
  required String hash,
  required String privateKeyHex,
}) async {
  final typedDataHash = hashTypedData(
    chainId: chainId,
    name: name,
    verifyingContract: verifyingContract,
    version: version,
    hash: hash,
  );
  return signHash(typedDataHash, privateKeyHex);
}
