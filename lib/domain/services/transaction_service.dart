abstract interface class TransactionService {
  Future<String> sendTransaction({
    required String encryptedJsonAccount,
    required String password,
    required String to,
    required BigInt amountInWei,
    required String rpcUrl,
    BigInt? gasPrice,
    int? maxGas,
  });
}
