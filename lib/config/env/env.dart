abstract class Env {
  static const defaultSepoliaRpc = String.fromEnvironment('DEFAULT_SEPOLIA_RPC');
  static const defaultEthereumMainnetRpc = String.fromEnvironment('DEFAULT_ETHEREUM_MAINNET_RPC');
  static const defaultFantomTestnetRpc = String.fromEnvironment(
    'DEFAULT_FANTOM_TESTNET_RPC',
    defaultValue: "https://fantom.api.onfinality.io/public",
  );
}
