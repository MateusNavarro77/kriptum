abstract interface class GasPriceService {
  Future<BigInt> fetchGasPrice({required String rpcUrl});
  Stream<BigInt> subscribeToGasPriceUpdates({
    required String rpcUrl,
    Duration interval = const Duration(seconds: 10),
  });
}
