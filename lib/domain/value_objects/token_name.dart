import 'package:kriptum/shared/utils/result.dart';

class TokenName {
  static const _maxWidth = 20;

  final String _value;
  TokenName._(this._value);

  @override
  int get hashCode => _value.hashCode;

  String get value => _value;

  @override
  bool operator ==(covariant TokenName other) {
    if (identical(this, other)) return true;

    return other._value == _value;
  }

  static Result<TokenName, String> create(String value) {
    final sanitizedValue = _sanitize(value);
    final errorReason = _validate(sanitizedValue);

    if (errorReason != null) {
      return Result.failure(errorReason);
    }
    return Result.success(TokenName._(sanitizedValue));
  }

  static String _sanitize(String value) {
    return value.trim();
  }

  static String? _validate(String value) {
    if (value.isEmpty) {
      return 'Token name cannot be empty';
    }
    if (value.length > _maxWidth) {
      return 'Token name must be lower or equal to $_maxWidth chars';
    }
    return null;
  }
}
