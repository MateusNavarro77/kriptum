// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kriptum/shared/utils/result.dart';

class Password {
  final String _value;
  Password._(this._value);
  @override
  int get hashCode => _value.hashCode;
  String get value => _value;

  @override
  bool operator ==(covariant Password other) {
    if (identical(this, other)) return true;

    return other._value == _value;
  }

  static Result<Password, String> create(String value) {
    final sanitizedValue = sanitize(value);
    final errorReason = _validate(sanitizedValue);

    if (errorReason != null) {
      return Result<Password, String>.failure(errorReason);
    }
    return Result<Password, String>.success(Password._(sanitizedValue));
  }

  static String sanitize(String value) {
    return value.trim();
  }

  static String? _validate(String value) {
    if (value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (value.length > 31) {
      return 'Password too large';
    }
    return null;
  }
}
