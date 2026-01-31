import '../pad.dart';

class ParsedSignature {
  final String r;
  final String s;
  final int? v;
  final int? yParity;

  ParsedSignature({required this.r, required this.s, this.v, this.yParity});
}

/// Parse hex signature (65 bytes: r(32) s(32) v(1)) into r, s, v/yParity.
ParsedSignature parseSignature(String signatureHex) {
  final h = signatureHex.startsWith('0x') ? signatureHex.substring(2) : signatureHex;
  if (h.length != 130) throw ArgumentError('Signature must be 65 bytes (130 hex chars)');
  final rHex = '0x${h.substring(0, 64)}';
  final sHex = '0x${h.substring(64, 128)}';
  final vOrY = int.parse(h.substring(128, 130), radix: 16);
  int? v;
  int? yParity;
  if (vOrY == 0 || vOrY == 1) {
    yParity = vOrY;
  } else if (vOrY == 27) {
    v = 27;
    yParity = 0;
  } else if (vOrY == 28) {
    v = 28;
    yParity = 1;
  } else {
    throw ArgumentError('Invalid yParity/v value: $vOrY');
  }
  return ParsedSignature(
    r: padHex(rHex, size: 32),
    s: padHex(sHex, size: 32),
    v: v,
    yParity: yParity,
  );
}
