import 'package:kriptum/shared/utils/result.dart';

class Mnemonic {
  final String _phrase;

  Mnemonic._(this._phrase);

  @override
  int get hashCode => _phrase.hashCode;

  String get value => _phrase;

  @override
  bool operator ==(covariant Mnemonic other) {
    if (identical(this, other)) return true;

    return other._phrase == _phrase;
  }

  static Result<Mnemonic, String> create(String phrase) {
    final errorReason = _validate(phrase);
    if (errorReason != null) {
      return Result.failure(errorReason);
    }
    return Result.success(Mnemonic._(phrase));
  }

  static String? _validate(String phrase) {
    if (phrase.isEmpty) {
      return 'Mnemonic phrase cannot be empty';
    }
    if (phrase.split(' ').length != 12) {
      return 'Mnemonic phrase must contain 12 words';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(phrase)) {
      return 'Mnemonic phrase can only contain letters and spaces';
    }
    return null;
  }
}
