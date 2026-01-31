import 'package:convert/convert.dart';

import 'concat.dart';
import 'encoding.dart';
import 'data_size.dart';
import 'keccak256.dart';

/// EIP-191 prefix for personal sign.
const presignMessagePrefix = '\x19Ethereum Signed Message:\n';

/// EIP-191: keccak256("\x19Ethereum Signed Message:\n" + len(message) + message)
/// [message] can be string or hex (with 0x).
String hashMessage(dynamic message) {
  String messageHex;
  if (message is String) {
    if (message.startsWith('0x')) {
      messageHex = message;
    } else {
      messageHex = stringToHex(message);
    }
  } else {
    throw ArgumentError('Message must be String');
  }
  final sizeInBytes = dataSize(messageHex);
  final prefixHex = stringToHex('$presignMessagePrefix$sizeInBytes');
  final combined = concatHex([prefixHex, messageHex]);
  final bytes =
      hex.decode(combined.startsWith('0x') ? combined.substring(2) : combined);
  return keccak256Hex(bytes);
}
