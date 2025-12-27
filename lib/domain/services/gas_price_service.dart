import 'package:kriptum/shared/contracts/disposable.dart';

abstract interface class GasPriceService implements Disposable {
  Future<BigInt> fetchGasPrice({required String rpcUrl});
  Stream<BigInt> subscribeToGasPriceUpdates({
    required String rpcUrl,
    Duration interval = const Duration(seconds: 10),
  });
}
