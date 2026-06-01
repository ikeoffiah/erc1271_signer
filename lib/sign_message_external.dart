import 'src/account_abstraction/sign_typed_data_owner.dart';
import 'src/account_abstraction/to_coinbase_smart_account.dart';
import 'src/chains/chains.dart';
import 'src/clients/public_client.dart';
import 'src/utils/hash_message.dart';
import 'src/utils/signature/wrap_signature.dart';

/// Signs a 32-byte hash and returns the 65-byte recoverable ECDSA signature.
///
/// Input: the replay-safe typed-data hash as a `0x`-prefixed 32-byte hex string.
/// Output: the signature as a `0x`-prefixed `r‖s‖v` (65-byte) hex string. The
/// recovery byte may be `0/1` or `27/28` — [wrapSignature] normalises it.
///
/// This lets the EOA private key live outside this package (e.g. in a
/// hardware/biometric SDK): the signer receives only the hash to sign.
typedef ExternalHashSigner = Future<String> Function(String hash);

/// Produces a Coinbase Smart Wallet ERC-1271 signature over [message] for a
/// smart account whose address is already known ([scaAddress]), delegating the
/// ECDSA step to [sign].
///
/// Network-free: callers that already resolved the SCA address (or computed it
/// via [coinbaseSmartAccountAddressForOwner]) can sign without an RPC round-trip.
/// [chainId] is the EIP-712 domain chain id (e.g. 8453 for Base).
Future<String> signReplaySafeMessage({
  required String scaAddress,
  required int chainId,
  required String message,
  required ExternalHashSigner sign,
}) async {
  final hash = hashMessage(message);
  final typedDataHash = hashTypedDataReplaySafe(
    address: scaAddress,
    chainId: chainId,
    hash: hash,
  );
  final signature = await sign(typedDataHash);
  return wrapSignature(ownerIndex: 0, signature: signature);
}

/// Signs [message] as the Coinbase Smart Wallet for the EOA [ownerAddress],
/// delegating the ECDSA step to [sign] instead of holding a private key.
///
/// Mirrors the top-level [signMessage] but takes an owner *address* + external
/// signer rather than a private key. Resolves the smart-account address via the
/// factory (one `eth_call`), then produces the ERC-1271 wrapped signature
/// (compatible with on-chain `isValidSignature`).
///
/// [chainName] is one of `base`, `baseSepolia`, `mainnet`, `sepolia`.
Future<String> signMessageWithExternalSigner({
  required String chainName,
  required String ownerAddress,
  required String message,
  required ExternalHashSigner sign,
  String version = '1.1',
  BigInt? nonce,
}) async {
  final chain = getChain(chainName);
  final client = PublicClient(chain: chain);
  final scaAddress = await coinbaseSmartAccountAddressForOwner(
    client: client,
    ownerAddress: ownerAddress,
    version: version,
    nonce: nonce,
  );
  return signReplaySafeMessage(
    scaAddress: scaAddress,
    chainId: chain.id,
    message: message,
    sign: sign,
  );
}
