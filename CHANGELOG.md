## 0.1.0

* Initial release.
* Coinbase Smart Wallet (SCA) message signing compatible with viem/ERC-1271.
* `signMessage(chainName, privateKey, message)` returns ERC-1271 wrapped signature.
* EIP-191 personal sign hashing and EIP-712 typed data hashing (replay-safe domain).
* Support for Base, Base Sepolia, Mainnet, Sepolia.
