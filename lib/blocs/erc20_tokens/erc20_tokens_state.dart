part of 'erc20_tokens_bloc.dart';

enum Erc20TokensStatus {
  initial,
  loading,
  loaded,
  error,
}

class Erc20TokensState {
  final Erc20TokensStatus status;
  final List<Erc20TokenWithBalance> tokens;
  final String errorMessage;
  const Erc20TokensState({
    required this.status,
    required this.tokens,
    required this.errorMessage,
  });
  factory Erc20TokensState.initial() {
    return Erc20TokensState(
      status: Erc20TokensStatus.initial,
      tokens: [],
      errorMessage: '',
    );
  }

  Erc20TokensState copyWith({
    Erc20TokensStatus? status,
    List<Erc20TokenWithBalance>? tokens,
    String? errorMessage,
  }) {
    return Erc20TokensState(
      status: status ?? this.status,
      tokens: tokens ?? this.tokens,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class Erc20TokenWithBalance {
  final Erc20Token token;
  final EthereumAmount balance;

  Erc20TokenWithBalance({
    required this.token,
    required this.balance,
  });
}
