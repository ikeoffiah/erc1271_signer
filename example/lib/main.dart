import 'package:erc1271_signer/erc1271_signer.dart';

void main() async {
  // Replace with your chain, private key, and message.
  const chainName = 'baseSepolia';
  const privateKey = '0x_your_private_key_here';
  const message = 'I hereby declare that I am the address owner.';

  print('Signing message with Coinbase Smart Wallet...');
  print('Chain: $chainName');
  print('Message: $message');
  print('');

  final signature = await signMessage(
    chainName: chainName,
    privateKey: privateKey,
    message: message,
  );

  print('Signature (ERC-1271 wrapped):');
  print(signature);
}
