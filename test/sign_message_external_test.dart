import 'package:erc1271_signer/erc1271_signer.dart';
import 'package:test/test.dart';

void main() {
  group('signReplaySafeMessage (external signer)', () {
    // Hardhat account #0 — a well-known test key. Used only to derive an EOA
    // signer for the golden comparison; never a real wallet.
    const testPrivateKey =
        '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';
    const scaAddress = '0x1234567890123456789012345678901234567890';

    test('reproduces CoinbaseSmartAccount.signMessage byte-for-byte', () async {
      final owner = privateKeyToAccount(testPrivateKey);
      // signMessage() only reads client.chain.id (no network) when the SCA
      // address is already known, so this comparison is network-free.
      final client = PublicClient(chain: base);
      const message = 'hello monerium';

      // Reference: the existing on-chain-proven private-key path.
      final expected = await CoinbaseSmartAccount(
        address: scaAddress,
        owner: owner,
        client: client,
      ).signMessage(message: message);

      // New path: identical hashing + wrap, but the ECDSA step is injected.
      final actual = await signReplaySafeMessage(
        scaAddress: scaAddress,
        chainId: base.id,
        message: message,
        sign: (hash) => owner.sign(hash: hash),
      );

      expect(actual, equals(expected));
    });

    test('matches across messages and is deterministic', () async {
      final owner = privateKeyToAccount(testPrivateKey);
      final client = PublicClient(chain: baseSepolia);

      for (final message in <String>['', 'a', 'order:12345:EUR:100.00']) {
        final expected = await CoinbaseSmartAccount(
          address: scaAddress,
          owner: owner,
          client: client,
        ).signMessage(message: message);

        final actual = await signReplaySafeMessage(
          scaAddress: scaAddress,
          chainId: baseSepolia.id,
          message: message,
          sign: (hash) => owner.sign(hash: hash),
        );

        expect(actual, equals(expected), reason: 'message="$message"');
      }
    });
  });
}
