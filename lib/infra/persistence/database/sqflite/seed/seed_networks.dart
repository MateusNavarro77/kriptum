import 'package:kriptum/config/env/env.dart';
import 'package:kriptum/domain/models/network.dart';

final seedNetworks = [
  Network(
      id: 11155111,
      rpcUrl: Env.defaultSepoliaRpc,
      name: 'Sepolia',
      ticker: 'ETH',
      currencyDecimals: 18,
      blockExplorerName: 'Sepolia Etherscan',
      blockExplorerUrl: 'https://sepolia.etherscan.io'),
  Network(
      id: 1,
      rpcUrl: Env.defaultEthereumMainnetRpc,
      name: 'Ethereum Mainnet',
      ticker: 'ETH',
      currencyDecimals: 18,
      blockExplorerName: 'Etherscan',
      blockExplorerUrl: 'https://etherscan.io'),
  Network(
    id: 4002,
    rpcUrl: Env.defaultFantomTestnetRpc,
    name: 'Fantom Testnet',
    ticker: 'FTM',
    currencyDecimals: 18,
    blockExplorerName: 'Fantom Scan',
    blockExplorerUrl: 'https://explorer.testnet.fantom.network',
  ),
  Network(
    id: 1337,
    rpcUrl: 'http://10.0.2.2:8545',
    name: 'Localhost',
    ticker: 'ETH',
    currencyDecimals: 18,
    blockExplorerName: 'Localhost Explorer',
    //blockExplorerUrl: 'http://10.0.2.2:3000'
  ),
];
