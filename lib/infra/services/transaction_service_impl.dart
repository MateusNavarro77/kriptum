import 'package:kriptum/domain/services/transaction_service.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class TransactionServiceImpl implements TransactionService {
  final http.Client _httpClient;

  TransactionServiceImpl(this._httpClient);

  @override
  Future<String> sendTransaction({
    required String encryptedJsonAccount,
    required String password,
    required String to,
    required BigInt amountInWei,
    required String rpcUrl,
    BigInt? gasPrice,
    int? maxGas,
  }) async {
    final ethClient = Web3Client(rpcUrl, _httpClient);
    final chainId = await ethClient.getChainId();
    final account = Wallet.fromJson(encryptedJsonAccount, password);
    final txHash = await ethClient.sendTransaction(
      chainId: chainId.toInt(),
      account.privateKey,
      Transaction(
        gasPrice: gasPrice != null ? EtherAmount.inWei(gasPrice) : null,
        from: account.privateKey.address,
        to: EthereumAddress.fromHex(to),
        value: EtherAmount.inWei(amountInWei),
        maxGas: maxGas,
      ),
    );
    return txHash;
  }
}
