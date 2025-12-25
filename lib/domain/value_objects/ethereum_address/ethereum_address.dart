import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address_validator.dart';
import 'package:kriptum/shared/utils/result.dart';

class EthereumAddress {
  static EthereumAddressValidator? _validator;
  final String _value;
  EthereumAddress._(this._value);

  @override
  int get hashCode => _value.hashCode;

  String get value => _value;
  String get withoutPrefix => _value.substring(2);
  @override
  bool operator ==(covariant EthereumAddress other) {
    if (identical(this, other)) return true;

    return other._value == _value;
  }

  static Result<EthereumAddress, String> create(String value) {
    if (_validator == null) {
      throw StateError('EthereumAddress validator not configured. Call EthereumAddress.setExternalValidator() first.');
    }
    final sanitizedValue = _sanitize(value);
    final errorReason = _validate(sanitizedValue);

    if (errorReason != null) {
      return Result.failure(errorReason);
    }
    return Result.success(EthereumAddress._(sanitizedValue));
  }

  static void setExternalValidator(EthereumAddressValidator? validator) {
    _validator = validator;
  }

  static String _sanitize(String value) {
    return value.trim();
  }

  static String? _validate(String value) {
    if (value.isEmpty) {
      return 'Ethereum address cannot be empty';
    }
    if (value.length != 42) {
      return 'Ethereum address must be 42 characters long';
    }
    if (!value.startsWith('0x')) {
      return 'Ethereum address must start with 0x';
    }
    if (!_validator!.validate(value)) {
      return 'Invalid Ethereum address format';
    }
    return null;
  }
}
