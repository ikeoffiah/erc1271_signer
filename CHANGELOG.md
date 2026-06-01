## 0.1.0

* Initial release.
* Coinbase Smart Wallet (SCA) message signing compatible with viem/ERC-1271.
* `signMessage(chainName, privateKey, message)` returns ERC-1271 wrapped signature.
* EIP-191 personal sign hashing and EIP-712 typed data hashing (replay-safe domain).
* Support for Base, Base Sepolia, Mainnet, Sepolia.


## 0.1.1

* Upgraded the web3dart package to the latest package.


## 0.1.2

* Updated the `lints` dev dependency from `^5.0.0` to `^6.1.0`.
* No changes to the public API or runtime dependencies; existing usage is unaffected.


## 0.2.0

* Added external-signer support so the EOA private key can live outside this
  package (e.g. in a hardware/biometric SDK):
  * `signMessageWithExternalSigner({chainName, ownerAddress, message, sign})` —
    resolves the smart-account address from the owner address and produces the
    ERC-1271 wrapped signature, delegating the ECDSA step to a `sign(hash)`
    callback.
  * `signReplaySafeMessage({scaAddress, chainId, message, sign})` — network-free
    variant for callers that already know the smart-account address.
  * `coinbaseSmartAccountAddressForOwner({client, ownerAddress})` — counterfactual
    SCA address from an owner address (no private key).
* Exported `hashTypedDataReplaySafe`.
* No behavioral change to the existing `signMessage(privateKey, ...)` path.