import '../utils/hash_message.dart';
import 'sign.dart';

/// EIP-191 personal sign: hash message then sign. Returns signature hex.
Future<String> signMessageWithPrivateKey(String message, String privateKeyHex) async {
  final hash = hashMessage(message);
  return signHash(hash, privateKeyHex);
}
