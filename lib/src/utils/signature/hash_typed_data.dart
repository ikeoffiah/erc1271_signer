import 'package:convert/convert.dart';

import '../concat.dart';
import '../keccak256.dart';
import '../encoding.dart';
import '../pad.dart';
import '../abi/encode_abi_parameters.dart';

/// EIP-712 hash for Coinbase replay-safe typed data:
/// domain: chainId, name, verifyingContract, version
/// primaryType: CoinbaseSmartWalletMessage, types: [{ name: 'hash', type: 'bytes32' }]
/// message: { hash }
String hashTypedData({
  required int chainId,
  required String name,
  required String verifyingContract,
  required String version,
  required String hash,
}) {
  const primaryType = 'CoinbaseSmartWalletMessage';
  final domainTypes = [
    {'name': 'name', 'type': 'string'},
    {'name': 'version', 'type': 'string'},
    {'name': 'chainId', 'type': 'uint256'},
    {'name': 'verifyingContract', 'type': 'address'},
  ];
  final messageTypes = [
    {'name': 'hash', 'type': 'bytes32'},
  ];

  // encodeType('CoinbaseSmartWalletMessage', types) -> "CoinbaseSmartWalletMessage(bytes32 hash)"
  final typeStr =
      '$primaryType(${messageTypes.map((t) => '${t['type']} ${t['name']}').join(',')})';
  final typeHash = keccak256Hex(hex.decode(stringToHex(typeStr).substring(2)));
  final domainTypeStr =
      'EIP712Domain(${domainTypes.map((t) => '${t['type']} ${t['name']}').join(',')})';
  final domainTypeHash =
      keccak256Hex(hex.decode(stringToHex(domainTypeStr).substring(2)));

  // hashStruct(domain) = keccak256(domainTypeHash || encodeData(domain))
  // EIP-712 encodeData: each field is 32 bytes; string = keccak256(utf8), uint256/address = 32-byte value
  final nameHash = keccak256Hex(hex.decode(stringToHex(name).substring(2)));
  final versionHash =
      keccak256Hex(hex.decode(stringToHex(version).substring(2)));
  final chainIdEnc = numberToHex(BigInt.from(chainId), size: 32);
  final addressEnc = padHex(verifyingContract.toLowerCase(), size: 32);
  final domainFieldsEncoded =
      concatHex([nameHash, versionHash, chainIdEnc, addressEnc]);
  final domainEncoded = concatHex([domainTypeHash, domainFieldsEncoded]);
  final hashDomain = keccak256Hex(hex.decode(domainEncoded.startsWith('0x')
      ? domainEncoded.substring(2)
      : domainEncoded));

  // hashStruct(message)
  final messageEncoded = encodeAbiParameters(
    [
      {'type': 'bytes32'},
      {'type': 'bytes32'},
    ],
    [typeHash, padHex(hash, size: 32)],
  );
  final hashStruct = keccak256Hex(hex.decode(messageEncoded.startsWith('0x')
      ? messageEncoded.substring(2)
      : messageEncoded));

  // 0x1901 + hashDomain + hashStruct
  final combined = concatHex(['0x1901', hashDomain, hashStruct]);
  final bytes =
      hex.decode(combined.startsWith('0x') ? combined.substring(2) : combined);
  return keccak256Hex(bytes);
}
