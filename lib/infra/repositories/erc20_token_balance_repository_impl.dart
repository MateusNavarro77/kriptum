import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/erc20_token_balance_repository.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/infra/datasources/data_sources.dart';

class Erc20TokenBalanceRepositoryImpl implements Erc20TokenBalanceRepository {
  final Erc20TokenBalanceDataSource _erc20tokenBalanceDataSource;

  Erc20TokenBalanceRepositoryImpl(this._erc20tokenBalanceDataSource);
  @override
  Future<EthereumAmount> getBalance({
    required String erc20ContractAddress,
    required String accountAddress,
    required Network network,
  }) async {
    //TODO: implement caching
    return await _erc20tokenBalanceDataSource.getErc20BalanceOfAccount(
      accountAddress: accountAddress,
      contractAddress: erc20ContractAddress,
      networkRpcUrl: network.rpcUrl,
    );
  }
}
