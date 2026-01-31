import 'chain.dart';

const base = Chain(
  id: 8453,
  name: 'Base',
  rpcUrl: 'https://mainnet.base.org',
);

const baseSepolia = Chain(
  id: 84532,
  name: 'Base Sepolia',
  rpcUrl: 'https://sepolia.base.org',
);

const mainnet = Chain(
  id: 1,
  name: 'Ethereum',
  rpcUrl: 'https://eth.merkle.io',
);

const sepolia = Chain(
  id: 11155111,
  name: 'Sepolia',
  rpcUrl: 'https://rpc.sepolia.org',
);

final chains = <String, Chain>{
  'base': base,
  'baseSepolia': baseSepolia,
  'mainnet': mainnet,
  'sepolia': sepolia,
};

Chain getChain(String name) {
  final c = chains[name];
  if (c == null) {
    throw ArgumentError(
      'Unknown chain "$name". Supported: ${chains.keys.join(", ")}',
    );
  }
  return c;
}
