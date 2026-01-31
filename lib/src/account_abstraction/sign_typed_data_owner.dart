import '../utils/signature/hash_typed_data.dart';

/// Hash for Coinbase replay-safe typed data (domain + CoinbaseSmartWalletMessage).
String hashTypedDataReplaySafe({
  required String address,
  required int chainId,
  required String hash,
}) {
  return hashTypedData(
    chainId: chainId,
    name: 'Coinbase Smart Wallet',
    verifyingContract: address,
    version: '1',
    hash: hash,
  );
}
