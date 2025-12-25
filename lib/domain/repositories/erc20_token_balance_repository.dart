import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

abstract interface class Erc20TokenBalanceRepository {
  Future<EthereumAmount> getBalance({
    required String erc20ContractAddress,
    required String accountAddress,
    required Network network,
  });
}
