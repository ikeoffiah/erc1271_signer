import 'src/account_abstraction/to_coinbase_smart_account.dart';
import 'src/accounts/private_key_to_account.dart';
import 'src/chains/chains.dart';
import 'src/clients/public_client.dart';

/// Signs a message as the Coinbase Smart Wallet (SCA) for the given chain.
///
/// Returns the ERC-1271 wrapped signature (hex string). Compatible with
/// viem's `verifyMessage` and on-chain `isValidSignature`.
///
/// [chainName]: One of `base`, `baseSepolia`, `mainnet`, `sepolia`.
/// [privateKey]: EOA private key (with or without 0x prefix).
/// [message]: The message to sign.
Future<String> signMessage({
  required String chainName,
  required String privateKey,
  required String message,
}) async {
  final chain = getChain(chainName);
  final client = PublicClient(chain: chain);
  final owner = privateKeyToAccount(privateKey);
  final smartAccount = await toCoinbaseSmartAccount(
    client: client,
    owner: owner,
    version: '1.1',
  );
  return smartAccount.signMessage(message: message);
}
