import 'dart:convert';

import 'package:http/http.dart' as http;

import '../chains/chain.dart';
import '../utils/abi/encode_function_data.dart';

/// Minimal public client: readContract via eth_call.
class PublicClient {
  final Chain chain;

  PublicClient({required this.chain});

  String get rpcUrl => chain.rpcUrl;

  /// eth_call: to, data, returns result hex.
  Future<String> call({
    required String to,
    required String data,
  }) async {
    final body = jsonEncode({
      'jsonrpc': '2.0',
      'id': 1,
      'method': 'eth_call',
      'params': [
        {
          'to': to,
          'data': data,
        },
        'latest',
      ],
    });
    final resp = await http.post(
      Uri.parse(rpcUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (resp.statusCode != 200) {
      throw Exception('RPC error: ${resp.statusCode} ${resp.body}');
    }
    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    final error = map['error'];
    if (error != null) {
      throw Exception('RPC error: $error');
    }
    final result = map['result'] as String?;
    return result ?? '0x';
  }

  /// readContract: call and decode address (last 20 bytes of result).
  Future<String> readContractAddress({
    required String address,
    required String abiFunctionSignature,
    required List<Map<String, dynamic>> args,
    required List<dynamic> values,
  }) async {
    final data = encodeFunctionData(
      abiFunctionSignature: abiFunctionSignature,
      args: args,
      values: values,
    );
    final result = await call(to: address, data: data);
    // ABI address: 32 bytes, address in last 20 bytes (40 hex chars)
    if (result == '0x' || result.length < 2 + 64) {
      throw Exception('Invalid readContract result: $result');
    }
    final h = result.startsWith('0x') ? result.substring(2) : result;
    final addressHex = h.length >= 64 ? h.substring(24, 64) : h.padLeft(40, '0');
    return '0x${addressHex.toLowerCase()}';
  }
}
