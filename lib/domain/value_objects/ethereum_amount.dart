class EthereumAmount implements Comparable<EthereumAmount> {
  static final BigInt weiPerGwei = BigInt.from(10).pow(9);
  static final BigInt weiPerFinney = BigInt.from(10).pow(15);
  static final BigInt weiPerEther = BigInt.from(10).pow(18);

  final BigInt _wei;

  factory EthereumAmount.fromEther(BigInt ether) {
    return EthereumAmount._(ether * weiPerEther);
  }

  factory EthereumAmount.fromEtherDecimal(String ether) {
    if (ether.contains(',')) {
      ether = ether.replaceAll(',', '.');
    }
    if (ether.startsWith('.')) {
      throw ArgumentError('Cannot start with .');
    }
    final parts = ether.split('.');
    final integerPart = BigInt.parse(parts[0]);

    BigInt fractionalWei = BigInt.zero;

    if (parts.length == 2) {
      final fractional = parts[1].padRight(18, '0').substring(0, 18);
      fractionalWei = BigInt.parse(fractional);
    }

    return EthereumAmount._(
      integerPart * weiPerEther + fractionalWei,
    );
  }

  factory EthereumAmount.fromFinney(BigInt finney) {
    return EthereumAmount._(finney * weiPerFinney);
  }

  factory EthereumAmount.fromGwei(BigInt gwei) {
    return EthereumAmount._(gwei * weiPerGwei);
  }

  factory EthereumAmount.fromWei(BigInt wei) {
    return EthereumAmount._(wei);
  }

  const EthereumAmount._(this._wei);

  BigInt get ether => _wei ~/ weiPerEther;

  BigInt get finney => _wei ~/ weiPerFinney;

  BigInt get gwei => _wei ~/ weiPerGwei;
  @override
  int get hashCode => _wei.hashCode;

  BigInt get wei => _wei;

  bool operator <(EthereumAmount other) => _wei < other._wei;

  bool operator <=(EthereumAmount other) => _wei <= other._wei;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EthereumAmount && _wei == other._wei;

  bool operator >(EthereumAmount other) => _wei > other._wei;

  bool operator >=(EthereumAmount other) => _wei >= other._wei;

  EthereumAmount add(EthereumAmount other) {
    return EthereumAmount._(_wei + other._wei);
  }

  @override
  int compareTo(EthereumAmount other) {
    return _wei.compareTo(other._wei);
  }

  EthereumAmount divide(BigInt divisor) {
    return EthereumAmount._(_wei ~/ divisor);
  }

  EthereumAmount multiply(BigInt factor) {
    return EthereumAmount._(_wei * factor);
  }

  EthereumAmount sub(EthereumAmount other) {
    return EthereumAmount._(_wei - other._wei);
  }

  String toEtherString({int decimals = 18}) {
    if (decimals < 0 || decimals > 18) {
      throw ArgumentError('Decimals must be between 0 and 18');
    }

    return _formatWithDecimals(_wei, decimals);
  }

  String toEtherStringFull() {
    return _formatWithDecimals(_wei, 18);
  }

  static String _formatWithDecimals(BigInt wei, int decimals) {
    final integerPart = wei ~/ weiPerEther;
    final remainder = wei % weiPerEther;

    if (decimals == 0) {
      return integerPart.toString();
    }

    final fraction = remainder.toString().padLeft(18, '0').substring(0, decimals);

    return '$integerPart.$fraction';
  }
}
