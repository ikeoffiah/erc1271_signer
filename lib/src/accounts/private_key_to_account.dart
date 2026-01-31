import 'package:web3dart/crypto.dart';

import 'public_key_to_address.dart';
import 'sign.dart';
import 'sign_message.dart';
import 'sign_typed_data.dart';

/// Local account (EOA) from private key: address, publicKey, sign, signMessage, signTypedData.
PrivateKeyAccount privateKeyToAccount(String privateKeyHex) {
  final pk = privateKeyHex.startsWith('0x')
      ? privateKeyHex.substring(2)
      : privateKeyHex;
  if (pk.length != 64){
    throw ArgumentError('Private key must be 32 bytes (64 hex)');
  }
  final keyBytes = hexToBytes('0x$pk');
  final publicKey = privateKeyBytesToPublic(keyBytes);
  final publicKeyHex = '0x04${bytesToHex(publicKey, include0x: false)}';
  final address = publicKeyToAddressHex(publicKeyHex);
  return PrivateKeyAccount(
    address: address,
    publicKey: publicKeyHex,
    privateKeyHex: '0x$pk',
  );
}

class PrivateKeyAccount {
  final String address;
  final String publicKey;
  final String privateKeyHex;

  PrivateKeyAccount({
    required this.address,
    required this.publicKey,
    required this.privateKeyHex,
  });

  Future<String> sign({required String hash}) => signHash(hash, privateKeyHex);

  Future<String> signMessage({required String message}) =>
      signMessageWithPrivateKey(message, privateKeyHex);

  Future<String> signTypedData({
    required int chainId,
    required String name,
    required String verifyingContract,
    required String version,
    required String hash,
  }) =>
      signTypedDataWithKey(
        chainId: chainId,
        name: name,
        verifyingContract: verifyingContract,
        version: version,
        hash: hash,
        privateKeyHex: privateKeyHex,
      );
}
