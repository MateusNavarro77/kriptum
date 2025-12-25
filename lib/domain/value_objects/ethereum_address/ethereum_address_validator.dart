abstract interface class EthereumAddressValidator {
  /// Validates the provided [address] string as an Ethereum address.
  ///
  /// Returns `true` if the address is valid, `false` otherwise.
  bool validate(String address);
}