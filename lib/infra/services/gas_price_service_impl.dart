import 'package:http/http.dart' as http;
import 'package:kriptum/domain/services/gas_price_service.dart';
import 'package:web3dart/web3dart.dart' as web3;

class GasServiceImpl implements GasPriceService {
  final http.Client _httpClient;

  GasServiceImpl({required http.Client httpClient}) : _httpClient = httpClient;
  @override
  Future<BigInt> fetchGasPrice({required String rpcUrl}) async {
    final ethClient = web3.Web3Client(rpcUrl, _httpClient);
    final gasPrice = await ethClient.getGasPrice();
    await ethClient.dispose();
    return gasPrice.getInWei;
  }

  @override
  Stream<BigInt> subscribeToGasPriceUpdates({required String rpcUrl, Duration interval = const Duration(seconds: 10)}) {
    // TODO: implement subscribeToGasPriceUpdates
    throw UnimplementedError();
  }
}
