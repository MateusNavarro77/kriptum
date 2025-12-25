import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

abstract interface class NativeBalanceDataSource {
  Future<EthereumAmount> getNativeBalanceOfAccount({
    required String accountAddress,
    required Network network,
  });
}
