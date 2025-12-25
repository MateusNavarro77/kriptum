import 'package:kriptum/shared/utils/result.dart';

class TokenDecimals {
  final int _value;
  TokenDecimals._(this._value);

  int get value => _value;

  @override
  bool operator ==(covariant TokenDecimals other) {
    if (identical(this, other)) return true;

    return other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  static Result<TokenDecimals, String> create(int value) {
    if (value < 0) {
      return Result.failure('Cannot be negative');
    }
    return Result.success(TokenDecimals._(value));
  }
}
