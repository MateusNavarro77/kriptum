import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address_validator.dart';
import 'package:web3dart/web3dart.dart' as web3;

class Web3EthereumAddressValidatorImpl implements EthereumAddressValidator {
  @override
  bool validate(String address) {
    try {
      web3.EthereumAddress.fromHex(address);
      return true;
    } catch (e) {
      return false;
    }
  }
}
