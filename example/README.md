# viem_dart example

Shows how to use [erc1271_signer](..) to sign a message as a Coinbase Smart Wallet.

## Run

1. From the **example** directory, get dependencies and run:

   ```bash
   cd example
   dart pub get
   dart run lib/main.dart
   ```

2. Edit `lib/main.dart` and set your `chainName`, `privateKey`, and `message` before running (use a test key; never commit real keys).

## What it does

Calls `signMessage(chainName:, privateKey:, message:)` and prints the ERC-1271 wrapped signature.
