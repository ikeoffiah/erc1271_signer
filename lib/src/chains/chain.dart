/// Chain: id and RPC URL for eth_call.
class Chain {
  final int id;
  final String name;
  final String rpcUrl;

  const Chain({
    required this.id,
    required this.name,
    required this.rpcUrl,
  });
}
