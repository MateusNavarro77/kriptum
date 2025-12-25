import 'package:kriptum/domain/models/network.dart';
import 'package:http/http.dart' as http;
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/infra/datasources/data_sources.dart';
import 'package:web3dart/web3dart.dart' as web3;

class NativeBalanceDataSourceImpl implements NativeBalanceDataSource {
  final http.Client _httpClient;
  NativeBalanceDataSourceImpl(this._httpClient);
  @override
  Future<EthereumAmount> getNativeBalanceOfAccount({
    required String accountAddress,
    required Network network,
  }) async {
    final web3Client = web3.Web3Client(network.rpcUrl, _httpClient);
    final balance = await web3Client.getBalance(web3.EthereumAddress.fromHex(accountAddress));
    return EthereumAmount.fromWei(balance.getInWei);
  }
}
