import 'package:http/http.dart' as http;
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

import 'package:kriptum/infra/datasources/data_sources.dart';
import 'package:web3dart/web3dart.dart' as web3;

class Erc20TokenBalanceDataSourceImpl implements Erc20TokenBalanceDataSource {
  final http.Client _httpClient;
  static const String _erc20Abi = '''
  [
    {"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}
  ]
  ''';
  Erc20TokenBalanceDataSourceImpl(this._httpClient);

  @override
  Future<EthereumAmount> getErc20BalanceOfAccount({
    required String accountAddress,
    required String contractAddress,
    required String networkRpcUrl,
  }) async {
    final client = web3.Web3Client(networkRpcUrl, _httpClient);
    final contract = web3.DeployedContract(
      web3.ContractAbi.fromJson(_erc20Abi, 'ERC20'),
      web3.EthereumAddress.fromHex(contractAddress),
    );

    final balanceFunction = contract.function('balanceOf');
    final address = web3.EthereumAddress.fromHex(accountAddress);

    final result = await client.call(
      contract: contract,
      function: balanceFunction,
      params: [address],
    );
    final balance = result.first as BigInt;
    return EthereumAmount.fromWei(balance);
  }
}
