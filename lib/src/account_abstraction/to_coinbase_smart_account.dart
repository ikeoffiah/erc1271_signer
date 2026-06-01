import '../accounts/private_key_to_account.dart';
import '../clients/public_client.dart';
import '../utils/hash_message.dart';
import '../utils/pad.dart';
import '../utils/signature/wrap_signature.dart';
import 'sign_typed_data_owner.dart';

const _factoryAddressV11 = '0xba5ed110efdba3d005bfc882d75358acbbb85842';
const _factoryAddressV1 = '0x0ba5ed0c6aa8c49038f819e587e2633c4a9f428a';

/// Coinbase Smart Account (version '1.1' or '1').
class CoinbaseSmartAccount {
  final String address;
  final PrivateKeyAccount owner;
  final PublicClient client;
  final String version;

  CoinbaseSmartAccount({
    required this.address,
    required this.owner,
    required this.client,
    this.version = '1.1',
  });

  /// Sign message as SCA: EIP-712 replay-safe hash then sign and wrap (ownerIndex, signature).
  Future<String> signMessage({required String message}) async {
    final hash = hashMessage(message);
    final typedDataHash = hashTypedDataReplaySafe(
      address: address,
      chainId: client.chain.id,
      hash: hash,
    );
    final signature = await owner.sign(hash: typedDataHash);
    return wrapSignature(ownerIndex: 0, signature: signature);
  }
}

/// Computes the counterfactual Coinbase Smart Account address for a single
/// owner identified by its EOA [ownerAddress] — no private key required.
///
/// Useful when the owner key is held externally (e.g. a hardware/biometric
/// signer) and only the address is known. Uses the same factory derivation as
/// [toCoinbaseSmartAccount].
Future<String> coinbaseSmartAccountAddressForOwner({
  required PublicClient client,
  required String ownerAddress,
  String version = '1.1',
  BigInt? nonce,
}) async {
  final nonceValue = nonce ?? BigInt.zero;
  final ownersBytes = [padHex(ownerAddress, size: 32)];
  final factoryAddress =
      version == '1.1' ? _factoryAddressV11 : _factoryAddressV1;
  return client.readContractAddress(
    address: factoryAddress,
    abiFunctionSignature: 'getAddress(bytes[],uint256)',
    args: [
      {'type': 'bytes[]'},
      {'type': 'uint256'},
    ],
    values: [ownersBytes, nonceValue],
  );
}

/// Create Coinbase Smart Account from client and owner(s). Version '1.1' or '1'.
Future<CoinbaseSmartAccount> toCoinbaseSmartAccount({
  required PublicClient client,
  required PrivateKeyAccount owner,
  String version = '1.1',
  BigInt? nonce,
}) async {
  final address = await coinbaseSmartAccountAddressForOwner(
    client: client,
    ownerAddress: owner.address,
    version: version,
    nonce: nonce,
  );
  return CoinbaseSmartAccount(
    address: address,
    owner: owner,
    client: client,
    version: version,
  );
}
