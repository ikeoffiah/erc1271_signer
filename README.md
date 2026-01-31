# erc1271_signer

Dart port of [viem](https://viem.sh)-style utilities for Ethereum: **Coinbase Smart Wallet** message signing, EIP-191 / EIP-712 hashing, and ERC-1271-compatible signatures.

## Features

- **Coinbase Smart Wallet (SCA)** message signing compatible with viem and ERC-1271
- EIP-191 personal sign message hashing
- EIP-712 typed data hashing (replay-safe domain for Coinbase Smart Wallet)
- Supported chains: Base, Base Sepolia, Mainnet, Sepolia

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  erc1271_signer: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Usage

Pass **chain**, **privateKey**, and **message** to get the ERC-1271 wrapped signature:

```dart
import 'package:erc1271_signer/erc1271_signer.dart';

void main() async {
  final signature = await signMessage(
    chainName: 'baseSepolia',
    privateKey: '0x_your_private_key',
    message: 'I hereby declare that I am the address owner.',
  );
  // Use signature with ERC-1271 / verify on-chain or with viem verifyMessage
  print(signature);
}
```

**Chain names:** `base`, `baseSepolia`, `mainnet`, `sepolia`.

For lower-level control (client, account, smart account), use the exported APIs: `getChain`, `privateKeyToAccount`, `toCoinbaseSmartAccount`, `PublicClient`, etc.

## Example

See the [example/](example/) app:

```bash
cd example
dart pub get
dart run lib/main.dart
```

Edit `example/lib/main.dart` to set your `chainName`, `privateKey`, and `message` (use a test key only).

## Verification

Signatures produced by this package can be verified with viem’s `publicClient.verifyMessage()` (ERC-1271 / ERC-6492) using the same chain, smart account address, message, and signature.

