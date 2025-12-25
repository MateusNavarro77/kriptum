import 'package:kriptum/shared/utils/result.dart';

class TokenSymbol {
  final String _value;
  static const _maxWidth = 10;

  TokenSymbol._(this._value);

  String get value => _value;

  @override
  bool operator ==(covariant TokenSymbol other) {
    if (identical(this, other)) return true;

    return other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;

  static Result<TokenSymbol, String> create(String value) {
    final sanitizedValue = _sanitize(value);
    final errorReason = _validate(sanitizedValue);

    if (errorReason != null) {
      return Result.failure(errorReason);
    }
    return Result.success(TokenSymbol._(sanitizedValue));
  }

  static String _sanitize(String value) {
    return value.trim();
  }

  static String? _validate(String value) {
    if (value.isEmpty) {
      return 'Token symbol cannot be empty';
    }
    if (value.length > _maxWidth) {
      return 'Symbol must be lower or equal to $_maxWidth chars';
    }
    return null;
  }
}
