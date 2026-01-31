import 'dart:convert';

import 'package:convert/convert.dart';

import '../concat.dart';
import '../encoding.dart';
import '../pad.dart';
import '../data_size.dart';

/// Minimal ABI encode for types we need: uint8, uint256, bytes32, bytes, address, tuple, bytes[].
String encodeAbiParameters(List<Map<String, dynamic>> params, List<dynamic> values) {
  if (params.length != values.length) {
    throw ArgumentError('Params and values length mismatch');
  }
  final staticParts = <String>[];
  final dynamicParts = <String>[];
  int dynamicOffset = params.length * 32;

  for (int i = 0; i < params.length; i++) {
    final param = params[i];
    final value = values[i];
    final type = param['type'] as String? ?? param['name'] as String? ?? '';

    if (type == 'uint8' || type == 'uint256') {
      final v = value is BigInt ? value : BigInt.from(value as int);
      staticParts.add(numberToHex(v, size: 32));
    } else if (type == 'bytes32' || type == 'address') {
      final h = _ensureHex(value);
      staticParts.add(padHex(h, size: 32));
    } else if (type == 'string') {
      staticParts.add(numberToHex(BigInt.from(dynamicOffset), size: 32));
      final s = value as String;
      final bytes = _utf8.encode(s);
      final len = bytes.length;
      final paddedLen = ((len + 31) ~/ 32) * 32;
      dynamicParts.add(numberToHex(BigInt.from(len), size: 32));
      dynamicParts.add(padHex('0x${hex.encode(bytes)}', size: paddedLen == 0 ? 32 : paddedLen, right: true));
      dynamicOffset += 32 + (paddedLen == 0 ? 32 : paddedLen);
    } else if (type == 'bytes') {
      staticParts.add(numberToHex(BigInt.from(dynamicOffset), size: 32));
      final h = _ensureHex(value);
      final len = dataSize(h);
      final paddedLen = ((len + 31) ~/ 32) * 32;
      final padded = padHex(h, size: paddedLen == 0 ? 32 : paddedLen, right: true);
      dynamicParts.add(numberToHex(BigInt.from(len), size: 32));
      dynamicParts.add(padded);
      dynamicOffset += 32 + paddedLen;
    } else if (type == 'tuple' && param['components'] != null) {
      final components = param['components'] as List<Map<String, dynamic>>;
      final tupleValues = value as List<dynamic>;
      final encoded = encodeAbiParameters(components, tupleValues);
      staticParts.add(encoded);
    } else if (type == 'bytes[]') {
      // ABI bytes[]: offset to array; at offset: [length][offset0][offset1]...[len0][data0]...
      // Offsets inside the array are relative to the start of the array (the length word).
      staticParts.add(numberToHex(BigInt.from(dynamicOffset), size: 32));
      final list = value as List;
      final n = list.length;
      int elemOffset = 32; // first element (length+data) starts 32 bytes after array length word
      dynamicParts.add(numberToHex(BigInt.from(n), size: 32));
      for (final _ in list) {
        dynamicParts.add(numberToHex(BigInt.from(elemOffset), size: 32));
        elemOffset += 32 + 32; // len (32) + data (32 bytes each)
      }
      for (final elem in list) {
        final h = _ensureHex(elem);
        dynamicParts.add(numberToHex(BigInt.from(32), size: 32)); // each elem 32 bytes
        dynamicParts.add(padHex(h, size: 32));
      }
      dynamicOffset += 32 + n * 32 + n * (32 + 32);
    } else {
      throw UnimplementedError('ABI type: $type');
    }
  }

  return concatHex(staticParts + dynamicParts);
}

final _utf8 = utf8;

String _ensureHex(dynamic value) {
  if (value is String) return value.startsWith('0x') ? value : '0x$value';
  if (value is List<int>) return '0x${hex.encode(value)}';
  throw ArgumentError('Expected hex or bytes');
}
