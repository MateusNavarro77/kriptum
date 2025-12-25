import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
  
abstract interface class Erc20TokenBalanceDataSource {
  Future<EthereumAmount> getErc20BalanceOfAccount({
    required String accountAddress,
    required String contractAddress,
    required String networkRpcUrl,
  });
}
